#!/usr/bin/env bash
read -p 'access_key: ' ACCESSKEY
read -p 'secret_key: ' SECRETKEY
#read -p 'ssh-key-name: ' SSH
AK=$(echo \"$ACCESSKEY\")
SK=$(echo \"$SECRETKEY\")

echo $AK
echo $SK
read -p 'is it ok? ' non

#export ACCESS_KEY=$(echo $AK)
#export SECRET_KEY=$(echo $SK)
#cat ./aws-template-creds > ~/.aws/credentials
#cat ./variables-tmp > ./variables.tf
#sed -ie "s/ACCESS_KEY/$AK/g" ~/.aws/credentials
#sed -ie "s|SECRET_KEY|$SK|g"  ~/.aws/credentials
#sed -ie "s/ACCESS_KEY/$AK/g" ./variables.tf
#sed -ie "s|SECRET_KEY|$SK|g" ./variables.tf
#terraform apply -auto-approve

if [ -d "/home/cloud_user/k8s" ] 
then
  cd /home/cloud_user/k8s/
else 
  mkdir -p /home/cloud_user/k8s && cd /home/cloud_user/k8s/ && echo "CREATEDDDDDD k8s dir"
fi


if [ -d "./kubespray-2.18.1" ]
then 
  cd kubespray-2.18.1
else
  wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.1.tar.gz && tar -zxf v2.18.1.tar.gz && cd kubespray-2.18.1 && echo "CD TO KUBESPRAYYYYYY"
fi


cd /home/cloud_user/k8s/kubespray-2.18.1/contrib/terraform/aws && echo "CD TO AWSSSSSSSS"
if [ -f "credentials.tfvars" ]
then 
  echo "credentails EXISTTTTSSSS"
else
  cp credentials.tfvars.example credentials.tfvars && echo "COPIES THE CREDENTAILSSSSS"
fi

if grep -q -w "sh-key-for-me" create-infrastructure.tf
then 
  echo "KEY EXSISTSSSSSSS"
else 
  cat << EOF >>create-infrastructure.tf
resource "aws_key_pair" "sh-key-for-me" {
  key_name = "My_Key"
  public_key = file("/root/.ssh/id_rsa.pub")
}
EOF
  echo "APENDED KEY CONFIG RESOURCE"
fi

sed -ie 's|AWS_SECRET_ACCESS_KEY = \"\"|AWS_SECRET_ACCESS_KEY = \"aws_key_pair.sh-key-for-me.key_name\"|g' create-infrastructure.tf
sed -ie 's|var.AWS_SSH_KEY_NAME|aws_key_pair.sh-key-for-me.key_name|g' create-infrastructure.tf
sed -ie "s|AWS_SECRET_ACCESS_KEY = \"\"|AWS_SECRET_ACCESS_KEY = $SK|g" credentials.tfvars
sed -ie "s|AWS_ACCESS_KEY_ID = \"\"|AWS_ACCESS_KEY_ID = $AK|g" credentials.tfvars
sed -ie 's|AWS_SSH_KEY_NAME = \"\"|AWS_SSH_KEY_NAME = \"sh-key-for-me\"|' credentials.tfvars
sed -ie 's|AWS_DEFAULT_REGION = \"eu-central\-1\"|AWS_DEFAULT_REGION = \"us-east\-1\"|' credentials.tfvars
sed -ie "s/aws_access_key_id.*/aws_access_key_id = $AK/g" ~/.aws/credentials
sed -ie "s|aws_secret_access_key.*|aws_secret_access_key = $SK|g"  ~/.aws/credentials
sed -ie 's/\"//g' ~/.aws/credentials

terraform init
terraform apply -auto-approve -var-file credentials.tfvars


#aws ec2 wait instance-status-ok --region us-east-1 --instance-ids  && echo "instances are ready"
BASTION=$(terraform output | grep "bastion ansible" | cut -d = -f 2 | head -n 1)
MASTER0=$(terraform output | grep -A1 "masters" | tail -n 1)
MASTER0ID=$(terraform state show aws_instance.k8s-master[0] | grep id | head -n 1 | awk '{print $3}' | sed 's/\"//g' )
aws ec2 wait instance-status-ok --region us-east-1 --instance-ids $MASTER0ID  && echo "instances are ready"

cd /home/cloud_user/k8s/kubespray-2.18.1/

pip3 install -r requirements.txt

scp ~/.ssh/id_rsa* admin@$BASTION:~/

ssh admin@$BASTION "sudo cp -r id_rsa* /root/.ssh/ && sudo cp -r id_rsa* ~/.ssh/"

ssh admin@$BASTION "sudo apt-get update && sudo apt-get install -y python-selinux"

read -p 'please verify first' verif

python3.6 $(which ansible-playbook) -i ./inventory/hosts ./cluster.yml -e ansible_user=admin -b --become-user=root

ssh admin@$BASTION "mkdir ~/.kube ; scp admin@$MASTER0:/etc/kubernetes/admin.conf ~/.kube/config"

if "ssh admin@$BASTION 'kubectl get nodes'" 
then
  echo "kubectl is accessible on bastion"
else
  echo "ERROOORR on running kubectl on bastion host"

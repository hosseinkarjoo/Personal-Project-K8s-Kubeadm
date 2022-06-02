FROM python:3.8-alpine
COPY ./requirements.txt /app/requirements.txt

#ENV FLASK_ENV=development
ENV FLASK_APP=main.py
ENV FLASK_DEBUG=1
RUN pip install --upgrade pip
RUN yum install mysql-server -y
#RUN pip install Flask
#RUN pip install mysqlclient
#RUN pip install flask-mysqldb
WORKDIR /app
#RUN apt-get install default-libmysqlclient-dev
#RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY . /app
EXPOSE  5000
ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
#CMD ['sleep 5000']

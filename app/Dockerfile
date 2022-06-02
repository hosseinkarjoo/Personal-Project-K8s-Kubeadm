FROM python:3

ENV FLASK_APP=main.py
ENV FLASK_DEBUG=1
ENV DEBUG_METRICS=true

RUN mkdir /app     
WORKDIR /app
COPY requirements.txt /app/   
RUN  pip3 install -r  requirements.txt
COPY . /app/
EXPOSE  5000
ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0"]

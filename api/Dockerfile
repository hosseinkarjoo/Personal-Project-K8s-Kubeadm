FROM python:3 as BASE

ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1

RUN mkdir /app     
WORKDIR /app
COPY requirements.txt /app/   
RUN  pip install -r  requirements.txt
COPY . /app

from BASE

EXPOSE  5001
ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5001"]

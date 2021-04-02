FROM ubuntu:18.04

LABEL maintainer lindynetech@gmail.com

RUN apt-get update && \
    apt-get install -y python python-pip && \
    pip install flask

COPY ./app.py .

ENTRYPOINT ["python", "app.py"]
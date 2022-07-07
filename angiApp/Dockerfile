FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENV APP=angi
ENV FLASK_ENV=development

ENTRYPOINT ["python", "app.py"]

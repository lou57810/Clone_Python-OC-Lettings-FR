# base image
FROM python:3.12

ENV PYTHONBUFFERED = 1
# Eviter les fichiers .pyc dans les containers --> ralentissements
ENV PYTHONDONTWRITEBYTECODE = 1

RUN mkdir /app

# copy all content to work directory /app
COPY . /app
WORKDIR /app

# install dependencies in requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt
RUN python manage.py collectstatic --noinput
 
ADD oc-lettings-site.sqlite3 /app

ENV SENTRY_DSN='https://4fe1df4c12e0ff56d4aec441e9a43f33@o4506869492940800.ingest.us.sentry.io/4507753280045056'
ENV SENTRY_ENVIRONMENT=production

# specify the port number the container should expose
EXPOSE 8000:8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "oc_lettings_site.wsgi:application"]

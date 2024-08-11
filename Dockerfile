FROM python:3.12-alpine3.19

LABEL maintainer="jhonatanmoncada@gmail.com"

# Evitar delay en la terminal
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# 1. Crea un entorno virtual
# 2. Actualiza pip
# 3. Instala las dependencias de requirements.txt
# 4. Elimina el contenido de la carpeta tmp
# 5. Crea el usuario django-user , sin contraseña y sin directorio home
#    se crea el usuario para evitar usar el root
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Establece como nuevo path de pyhton del sistema el entorno creado
ENV PATH="/py/bin:$PATH"

# Ingresa con el usuario creado 
USER django-user
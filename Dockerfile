FROM  python:3.7.2-alpine3.9 AS web_base

ARG UID=1000
ARG GID=1000
ARG USER=app

RUN addgroup -g $GID $USER && \
    adduser -u $UID -h /opt/$USER -G $USER -D $USER

WORKDIR /opt/$USER

COPY packages.txt .
RUN apk add --no-cache `cat packages.txt|grep -v ^#`

COPY build_deps.txt requirements.txt ./
RUN apk add --no-cache --virtual .build-deps `cat build_deps.txt|grep -v ^#` && \
	pip3 install --no-cache-dir --upgrade pip -r requirements.txt && \
	apk del --no-cache .build-deps

COPY . .
RUN chown -R $USER:$USER .

USER $USER
ENV PYTHONUNBUFFERED 1

FROM web_base AS web_test

USER root
COPY requirements-test.txt ./
RUN pip3 install --no-cache-dir --upgrade pip -r requirements-test.txt

USER $USER
ENV PYTHONUNBUFFERED 1

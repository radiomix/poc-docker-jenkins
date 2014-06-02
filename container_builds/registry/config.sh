#!/bin/bash

#
# This script contains variables for the docker registry container.
#


#MKL 2014.06.02

# These environment variables will be passed to the container`s config file 
# For a complete explanation look at https://github.com/dotcloud/docker-registry/blob/master/config/config_sample.yml

#MKL 
export SEARCH_BACKEND=sqlalchemy
export STORAGE_PATH=/registry-storage
export DOCKER_REGISTRY_CONFIG=/docker-registry/config/config.yml
export PRIVILEGED_KEY=/registry-storage/registry.public.pem
# To specify another flavor, set the environment variable SETTINGS_FLAVOR
export SETTINGS_FLAVOR=dev


export LOGLEVEL=debug
export STORAGE_REDIRECT
export STANDALONE=standalone
export INDEX_ENDPOINT
export DISABLE_TOKEN_AUTH
export PRIVILEGED_KEY
export SEARCH_BACKEND
export SQLALCHEMY_INDEX_DATABASE="sqlite:////tmp/docker-registry.db"
export MIRROR_SOURCE # https://registry-1.docker.io
export MIRROR_SOURCE_INDEX # https://index.docker.io
export MIRROR_TAGS_CACHE_TTL # 864000 # seconds

    # Enabling LRU cache for small files. This speeds up read/write on small files
    # when using a remote storage backend (like S3).
export CACHE_REDIS_HOST
export CACHE_REDIS_PORT
export CACHE_REDIS_PASSWORD
export CACHE_LRU_REDIS_HOST
export CACHE_LRU_REDIS_PORT
export CACHE_LRU_REDIS_PASSWORD

    # Enabling these options makes the Registry send an email on each code Exception
export SMTP_HOST
export SMTP_PORT=25
export SMTP_LOGIN
export SMTP_PASSWORD
export SMTP_SECURE=false
export SMTP_FROM_ADDR=docker-registry@localdomain.local
export SMTP_TO_ADDR=noise+dockerregistry@localdomain.local
    # Enable bugsnag (set the API key)
export BUGSNAG

    # storage: s3
export AWS_REGION
export AWS_BUCKET
export AWS_BUCKET
export STORAGE_PATH=/registry
export AWS_ENCRYPT=true
export AWS_SECURE=true
export AWS_KEY
export AWS_SECRET




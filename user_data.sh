#!/usr/bin/env bash

aws s3 cp ${S3_PATH} /home/ubuntu/postgrest/.env

sudo sed -i "s/RDS_HOST/${RDS_HOST}/g" /home/ubuntu/postgrest/.env

cd /home/ubuntu/postgrest

sudo docker-compose up -d

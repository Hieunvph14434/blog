#!/bin/bash

cd "$(dirname "$0")"
cd ..
docker-compose build
docker-compose up -d
docker-compose exec -T web cp .env.example .env
docker-compose exec -T web bundle install
docker-compose exec -T web rails db:create
docker-compose exec -T web rails db:migrate

echo "Done!!!"

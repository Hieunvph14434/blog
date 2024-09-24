#!/bin/bash

cd "$(dirname "$0")"
echo "Start Docker containers"
docker compose up -d

#!/bin/bash

# Quay về thư mục gốc của dự án
cd "$(dirname "$0")"

echo "Start Docker containers"
docker compose up -d

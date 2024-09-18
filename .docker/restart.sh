#!/bin/bash

# Quay về thư mục gốc của dự án
cd "$(dirname "$0")"

echo "Restart Docker containers"
docker compose restart


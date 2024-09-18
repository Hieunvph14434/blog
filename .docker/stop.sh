#!/bin/bash

# Quay về thư mục gốc của dự án
cd "$(dirname "$0")"

echo "Stop Docker containers"
docker compose down

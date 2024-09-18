#!/bin/bash

# Quay về thư mục gốc của dự án
cd "$(dirname "$0")"

echo "Exec Web Docker containers"
docker-compose exec web bash

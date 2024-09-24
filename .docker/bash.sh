#!/bin/bash

cd "$(dirname "$0")"
echo "Exec Web Docker containers"
docker-compose exec web bash

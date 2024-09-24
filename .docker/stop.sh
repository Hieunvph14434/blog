#!/bin/bash

cd "$(dirname "$0")"
echo "Stop Docker containers"
docker compose down

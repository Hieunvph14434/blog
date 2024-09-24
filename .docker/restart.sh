#!/bin/bash

cd "$(dirname "$0")"
echo "Restart Docker containers"
docker compose restart


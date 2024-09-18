#!/bin/bash

# Quay về thư mục gốc của dự án
cd "$(dirname "$0")"
cd ..

# Thực hiện các lệnh theo thứ tự
# Kiểm tra và sao chép file .env nếu chưa tồn tại
if [ ! -f .env ]; then
  echo "Sao chép file .env"
  cp .env.example .env
else
  echo "File .env đã tồn tại, bỏ qua sao chép."
fi

echo "Bước 1: Tạo dự án Rails"
docker-compose run web rails new . --force --database=postgresql

echo "Bước 2: Sao chép file database.yml"
cp .docker/pgsql/database.yml config/database.yml

echo "Bước 3: Build Docker containers"
docker-compose build

echo "Bước 4: Khởi động Docker containers"
docker-compose up -d
docker-compose run web bundle install
docker-compose run web bundle add dotenv-rails
docker-compose run web bundle install

echo "Bước 5: Create database"
docker-compose run web rails db:create

echo "Bước 6: Mirgate database"
docker-compose run web rails db:migrate

echo "Done!!!"

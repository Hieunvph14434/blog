# Sử dụng Ruby phiên bản 3.1 làm base image
FROM ruby:3.1

# Đặt biến môi trường cho người dùng và nhóm
ENV USER=www
ENV GROUP=www

# Cài đặt các dependencies cần thiết
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc là /var/www
WORKDIR /var/www

# Create User and Group
RUN groupadd -g 1000 ${GROUP} && \
    useradd -u 1000 -ms /bin/bash -g ${GROUP} ${USER}

# Grant Permissions
RUN chown -R ${USER} /var/www

# Select User
USER ${USER}

# Sao chép file Gemfile và Gemfile.lock vào container
COPY --chown=${USER}:${GROUP} Gemfile Gemfile.lock ./

# Cài đặt các gems từ Gemfile
RUN bundle install

# Copy permission to selected user
COPY --chown=${USER}:${GROUP} . .

# Mở port 3000 cho server Rails
EXPOSE 3000

# Khởi động server
CMD ["rails", "server", "-b", "0.0.0.0"]

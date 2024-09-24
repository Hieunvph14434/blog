# Use Ruby version 3.1 as the base image
FROM ruby:3.1

# Set environment variables for user and group
ENV USER=www
ENV GROUP=www

# Install necessary dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /var/www
WORKDIR /var/www

# Create User and Group
RUN groupadd -g 1000 ${GROUP} && \
    useradd -u 1000 -ms /bin/bash -g ${GROUP} ${USER}

# Grant permissions to the /var/www directory
RUN chown -R ${USER} /var/www

# Switch to the selected user
USER ${USER}

# Copy Gemfile and Gemfile.lock to the container
COPY --chown=${USER}:${GROUP} Gemfile Gemfile.lock ./

# Install the gems specified in Gemfile
RUN bundle install

# Copy project files with the correct permissions
COPY --chown=${USER}:${GROUP} . .

# Expose port 3000 for the Rails server
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]

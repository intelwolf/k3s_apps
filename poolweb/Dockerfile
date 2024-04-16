FROM php:7.4-apache

# Install necessary PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql
#Updating
RUN  apt-get update && apt-get upgrade -y && apt-get clean

# Start Apache when the container is run
CMD ["apache2-foreground"]
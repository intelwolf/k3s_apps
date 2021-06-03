FROM debian:buster-slim

# Set timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y python3-venv python3-pip nginx-full php-fpm sqlite3 php-sqlite3 python3-cairo python3-apt vim cron sudo logrotate && apt-get clean

RUN adduser --gecos "" --disabled-password p1mon && usermod -aG sudo p1mon && usermod -aG sudo www-data

# Setup sudo without password for p1mon and www-data
RUN echo >>/etc/sudoers "p1mon ALL=(ALL) NOPASSWD: ALL" && echo >>/etc/sudoers "www-data ALL=(p1mon) NOPASSWD: /p1mon/scripts/*"

# Install Python packages required
RUN pip3 install pythoncrc gunicorn bcrypt certifi cffi chardet colorzero dropbox falcon future gpiozero idna iso8601 paho-mqtt psutil pycparser pyserial python-crontab python-dateutil pytz PyYAML requests RPi.GPIO setuptools spidev urllib3

# Copy original p1mon directory
COPY p1mon/ /p1mon/

# Replace some scripts/settings and some other script:
COPY addons/ /

# Init file
COPY entrypoint.sh /

RUN sed -i "s/sudo nice --adjustment=-15 sudo -i -u p1mon //" /p1mon/scripts/p1mon.sh
# Create symlink to mimic local gunicorn
RUN mkdir -p /home/p1mon/.local/bin && ln -s /usr/local/bin/gunicorn /home/p1mon/.local/bin/gunicorn

ENTRYPOINT /entrypoint.sh

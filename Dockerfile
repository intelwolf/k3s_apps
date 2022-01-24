FROM debian:buster-slim

# Set timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y python3-venv python3-pip nginx-full php-fpm sqlite3 php-sqlite3 python3-cairo python3-apt vim cron sudo logrotate curl iputils-ping iproute2 libffi-dev socat && apt-get remove -y python3-xdg && apt-get clean

RUN addgroup -gid 997 gpio && adduser --disabled-password --gecos "P1Mon" p1mon && usermod -aG p1mon www-data && usermod -aG www-data,gpio p1mon

# Setup sudo without password for p1mon and www-data
RUN echo >>/etc/sudoers "p1mon ALL=(ALL) NOPASSWD: ALL" && echo >>/etc/sudoers "www-data ALL=(p1mon) NOPASSWD: /p1mon/scripts/*"

# Install Python packages required
RUN pip3 install pythoncrc gunicorn bcrypt certifi cffi chardet colorzero dropbox falcon future gpiozero idna iso8601 paho-mqtt psutil pycparser pyserial python-crontab python-dateutil pytz PyYAML requests RPi.GPIO setuptools spidev urllib3
# --no-cache-dir

# Copy original p1mon directory
COPY --chown=p1mon:p1mon p1mon/ /p1mon/

# Replace some scripts/settings and some other script:
COPY --chown=p1mon:p1mon addons/ /

# Init file
COPY entrypoint.sh /

HEALTHCHECK CMD curl -f http://127.0.0.1/nginx_status/ || exit 1

USER p1mon 

ENTRYPOINT ["/entrypoint.sh"]

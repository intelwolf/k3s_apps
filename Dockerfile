# Stage 1: Build dependencies
FROM python:slim-bullseye

RUN apt-get update && apt-get upgrade -y && \
#    apt-get install -y python3-pip \
#    python3-rpi.gpio \
     apt-get clean

RUN pip install pigpio influxdb-client paho-mqtt
# Set the working directory
WORKDIR /app

# Run your Python script
CMD ["python", "apprunner.py"]

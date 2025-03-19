FROM ubuntu:latest

# Insecure: Running as root
USER root

# Install outdated and vulnerable packages
RUN apt-get update && \
    apt-get install -y openssl curl wget && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Hardcoded credentials
ENV USERNAME="admin"
ENV PASSWORD="SuperSecret123"

# Expose SSH with default credentials
RUN apt-get update && apt-get install -y openssh-server && mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd  # Insecure: Hardcoded root password

# Install vulnerable Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Run an insecure web service
RUN echo "#!/bin/bash\necho 'Insecure Web Server Running'\npython2 -m SimpleHTTPServer 8080" > /start.sh && chmod +x /start.sh

EXPOSE 22 8080

CMD ["/bin/bash", "/start.sh"]

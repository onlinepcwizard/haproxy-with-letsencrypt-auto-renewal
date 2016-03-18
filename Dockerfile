FROM ubuntu:14.04

# Dependencies
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:vbernat/haproxy-1.6
RUN apt-get update -y
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y bc
RUN sudo apt-get install -y haproxy

# Install
RUN curl -sL https://github.com/letsencrypt/letsencrypt/archive/v0.4.2.tar.gz  | sudo tar xz -C /opt/
RUN sudo mv /opt/letsencrypt-0.4.2 /opt/letsencrypt
RUN sudo /opt/letsencrypt/letsencrypt-auto --help

ADD renew-certificate /usr/local/sbin/renew-certificate
RUN sudo chmod +x /usr/local/sbin/renew-certificate

# Crontab
ADD crontab /etc/cron.d/renew-certificate-cron
RUN chmod 0644 /etc/cron.d/renew-certificate-cron

# Services
RUN sudo service cron start
RUN sudo service haproxy stop

EXPOSE 443
EXPOSE 80

CMD ["sh", "-c", "INITIAL_RENEWAL=true /usr/local/sbin/renew-certificate && haproxy -f /usr/local/etc/haproxy/haproxy.cfg"]

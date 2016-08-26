FROM ubuntu:14.04

# Dependencies
RUN apt-get update -y
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:vbernat/haproxy-1.6
RUN apt-get update -y
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y bc
RUN sudo apt-get install -y haproxy
RUN sudo apt-get install -y supervisor

# Install
RUN mkdir -p /opt/letsencrypt
RUN curl -sL https://dl.eff.org/certbot-auto > /opt/letsencrypt/certbot-auto
RUN chmod a+x /opt/letsencrypt/certbot-auto
RUN /opt/letsencrypt/certbot-auto --os-packages-only --noninteractive

ADD renew-certificate /usr/local/sbin/renew-certificate
RUN sudo chmod +x /usr/local/sbin/renew-certificate
ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Crontab
ADD crontab /etc/cron.d/renew-certificate-cron
RUN chmod 0644 /etc/cron.d/renew-certificate-cron
RUN cron

EXPOSE 443
EXPOSE 80

CMD ["sh", "-c", "INITIAL_RENEWAL=true /usr/local/sbin/renew-certificate && /usr/bin/supervisord"]

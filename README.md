HAProxy with Letsencrypt Auto Renewal
=====================================

This container contains an HAProxy server with an auto Letsencrypt renewal service.

# Prerequisites

* Docker Compose

# Installation

```
docker pull tinganho/haproxy-with-letsencrypt-auto-renewal
```

# Configurations

Create a HAProxy configuration file in `/etc/haproxy/haproxy.cfg`. And add at least the following entries:
```text
global
    tune.ssl.default-dh-param 2048

frontend https
    bind *:443 ssl crt /usr/local/etc/haproxy/certs/domain.com.pem
    acl letsencrypt-acl path_beg /.well-known/acme-challenge/
    use_backend letsencrypt-backend if letsencrypt-acl

backend letsencrypt-backend
    server letsencrypt 127.0.0.1:54321
```

In your `docker-compose.yml` file add the following service:

```yml
haproxy:
  image: tinganho/haproxy-with-letsencrypt-auto-renewal
  ports:
    - 80:80
    - 443:443
  environment:
    # comma separated list of domains. The root domain must be the first entry.
    DOMAINS: domain.com, sub.domain.com
    EMAIL: user@domain.com
  volumes:
    - /etc/haproxy:/usr/local/etc/haproxy
    - /var/log/haproxy:/var/log/haproxy
```

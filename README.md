HAProxy with Letsencrypt Auto Renewal
=====================================

This container contains an HAProxy server and one Letencrypt renewal service.

Please create an haproxy configuration file in `/etc/haproxy/haproxy.cfg`. And add at least the following entries:
```text
global
	tune.ssl.default-dh-param 2048

frontend https
	acl letsencrypt-acl path_beg /.well-known/acme-challenge/
	use_backend letsencrypt-backend if letsencrypt-acl

backend letsencrypt-backend
	server letsencrypt 127.0.0.1:54321
```
Create a letsencrypt configuration file in `/usr/local/etc/letsencrypt.ini`:

```md
# This is an example of the kind of things you can do in a configuration file.
# All flags used by the client can be configured here. Run Let's Encrypt with
# "--help" to learn more about the available options.

# Use a 4096 bit RSA key instead of 2048
rsa-key-size = 4096

# Uncomment and update to register with the specified e-mail address
email = tingan87@gmail.com

# Uncomment and update to generate certificates for the specified
# domains.
domains = content.rosegarden.se

# Uncomment to use a text interface instead of ncurses
# text = True

# Uncomment to use the standalone authenticator
standalone-supported-challenges = http-01
```

In your `docker-compose.yml` file write add the following service:

```yml
haproxy:
  image: dg.flanity.com/haproxy
  ports:
    - 80:80
    - 443:443
  volumes:
    - /etc/haproxy:/etc/haproxy
    - /var/log/haproxy:/var/log/haproxy
	- /usr/local/etc/letsencrypt.ini:/usr/local/etc/letsencrypt.ini:ro
```

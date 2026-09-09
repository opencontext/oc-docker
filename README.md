# NOTE
This repo will hopefully streamline deployment of Open Context. The repo started by forking:
https://github.com/evgeniy-khist/letsencrypt-docker-compose




# Nginx and Let’s Encrypt with Docker Compose in less than 3 minutes

This example automatically obtains and renews [Let's Encrypt](https://letsencrypt.org/) TLS certificates and set up HTTPS in Nginx for multiple domain names using Docker Compose.

You can set up HTTPS in Nginx with Let's Encrypt TLS certificates for your domain names and get A+ rating at [SSL Labs SSL Server Test](https://www.ssllabs.com/ssltest/) by changing a few configuration parameters of this example.

Let's Encrypt is a certificate authority that provides free X.509 certificates for TLS encryption.
The certificates are valid for 90 days and can be renewed. Both initial creation and renewal can be automated using [Certbot](https://certbot.eff.org/).

When using Kubernetes Let's Encrypt TLS certificates can be easily obtained and installed using [Cert Manager](https://cert-manager.io/).
For simple web sites and applications Kubernetes is too much overhead and Docker Compose is more suitable.
But for Docker Compose there is no such popular and robust tool for TLS certificate management.

The example supports separate TLS certificates for multiple domain names, e.g. example.com, anotherdomain.net etc.
For simplicity this example deals with the following domain names:

* test1.devcomanda.com
* test2.devcomanda.com

The idea is simple. There are 3 containers:

* Nginx
* Certbot - for obtaining and renewing certificates
* Cron - for triggering certificates renewal once a day

The sequence of actions:

* Nginx generates self-signed "dummy" certificates to pass ACME challenge for obtaining Let's Encrypt certificates
* Certbot waits for Nginx to become ready and obtains certificates
* Cron triggers Certbot to try to renew certificates and Nginx to reload configuration on a daily basis

The directories and files:

* `docker-compose.yml`
* `.env` - specifies `COMPOSE_PROJECT_NAME` to make container names independent from the base directory name
* `config.env` - specifies project configuration, e.g. domain names, emails etc.
* `html/` - directory mounted as `root` for Nginx
    * `index.html`
* `nginx/`
    * `Dockerfile`
    * `nginx.sh` - entrypoint script
    * `hsts.conf` - HTTP Strict Transport Security (HSTS) policy
    * `default.conf` - Nginx configuration for all domains. Contains a configuration to get A+ rating at [SSL Server Test](https://www.ssllabs.com/ssltest/)
* `certbot/`
    * `Dockerfile`
    * `certbot.sh` - entrypoint script
* `cron/`
    * `Dockerfile`
    * `renew_certs.sh` - script executed on a daily basis to try to renew certificates

To adapt the example to your domain names you need to change only `config.env`:

```properties
DOMAINS=test1.devcomanda.com test2.devcomanda.com
CERTBOT_EMAILS=info@devcomanda.com info@devcomanda.com
CERTBOT_TEST_CERT=1
CERTBOT_RSA_KEY_SIZE=4096
```

Configuration parameters:

* `DOMAINS` - a space separated list of domains to manage certificates for
* `CERTBOT_EMAILS` - a space separated list of email for corresponding domains. If not specified, certificates will be obtained with `--register-unsafely-without-email`
* `CERTBOT_TEST_CERT` - use Let's Encrypt staging server (`--test-cert`)

Let's Encrypt has rate limits. So, while testing it's better to use staging server by setting `CERTBOT_TEST_CERT=1` (default value).
When you are ready to use production Let's Encrypt server, set `CERTBOT_TEST_CERT=0`.

## Prerequisites

1. [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) are installed
2. You have a domain name
3. You have a server with a publicly routable IP address
4. You have cloned this repository
   ```bash
   git clone https://github.com/opencontext/oc-docker.git
   ```

## Step 0 - Point your domain to server with DNS A records

For all domain names configure DNS A records to point to a server where Docker containers will be running.

## Step 1 - Edit domain names and emails in the configuration

Specify you domain names and contact emails for these domains in the `edit_dot_env` file and then save this file as `.env`:

First make an `.env` file
```bash
cp edit_dot_env .env
```

Now edit `.env` file to change your settings.
```bash
nano .env
```
Here are properties to change based on your specific Web domain. Please note, for now this only supports one domain specified by the `DOMAINS` variable (the plural is asperational..).

```properties
DOMAINS=prod.opencontext.org
CERTBOT_EMAILS=eric@opencontext.org
```

## Step 2 - Create named Docker volumes for dummy and Let's Encrypt TLS certificates

```bash
docker volume create --name=logs_nginx
docker volume create --name=nginx_ssl
docker volume create --name=certbot_certs
docker volume create --name=oc_certbot
docker volume create --name=redisdata
```

## Step 3 - Setup your static directory and secrets/secret.json
This process assumes that you have a copy of the static javascript and css files that are NOT
in version control with Open Context (yes, a pain.) Make sure the static directory and its contents
have the appropriate permissions:

```bash
sudo chmod -R 755 static/
```


## Step 4 - Build images and start containers

```bash
docker compose up --build
```

## Step 5 - Switch to production Let's Encrypt server after verifying HTTPS works with test certificates

Stop the containers:

```bash
docker compose down
```

Configure to use production Let's Encrypt server in `config.env`:

```properties
CERTBOT_TEST_CERT=0
```

Re-create the volume for Let's Encrypt certificates:

```bash
docker volume rm certbot_certs
docker volume create --name=certbot_certs
```

Start the containers:

```bash
docker compose up
```


## NOTE
You may run into weirdness permissions issues restarting the docker container. I solved it with:
```
sudo chmod 666 /var/run/docker.sock

```



## Useful Workflow Tips
One common need while the oc-docker compose is up and running would be to update the software in the Open Context container. To do so quickly, simply:

```
# This updates to the latest head of the staging branch:

docker exec -it oc git -C /open-context-py reset --hard origin/staging

# Now restart the container:
docker compose restart oc
```


## Externally Mounted Drive for Language Model and Filecache used by the OC container

These instructions are for Google Cloud deployment. Adapt them as needed for other cloud providers.

(1) Create a drive volume attached to the virtual machine instance `oc-language-model-disk-2026-09-08`
(2) SSH into the virtual machine instance and prepare the drive volume for use:

(3) Check that the new disk is attached to your virtual machine:
```bash
ls -l /dev/disk/by-id/google-*
```

You should see something like:
```
lrwxrwxrwx 1 root root  9 Sep  8 23:19 /dev/disk/by-id/google-oc-language-model-disk-2026-09-08 -> ../../sdb
lrwxrwxrwx 1 root root  9 Jul 14 11:27 /dev/disk/by-id/google-oc-production-docker-v2 -> ../../sda
lrwxrwxrwx 1 root root 10 Jul 14 11:27 /dev/disk/by-id/google-oc-production-docker-v2-part1 -> ../../sda1
lrwxrwxrwx 1 root root 11 Jul 14 11:27 /dev/disk/by-id/google-oc-production-docker-v2-part14 -> ../../sda14
lrwxrwxrwx 1 root root 11 Jul 14 11:27 /dev/disk/by-id/google-oc-production-docker-v2-part15 -> ../../sda15
```

(4) Format our `oc-language-model-disk-2026-09-08` disk, identified as `sdb`:

```bash
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
```

(5) Make a directory for the newly formatted drive, mount it, and make it read + write accessible:

```bash
sudo mkdir -p /mnt/disks/oc-language-model-disk-2026-09-08
sudo mount -o discard,defaults /dev/sdb /mnt/disks/oc-language-model-disk-2026-09-08
sudo chmod a+w /mnt/disks/oc-language-model-disk-2026-09-08
```

(5) Make some directories in the newly formatted and mounted drive. We'll need these for Open Context's use of language models:

```bash
sudo mkdir /mnt/disks/oc-language-model-disk-2026-09-08/oc_data
sudo mkdir /mnt/disks/oc-language-model-disk-2026-09-08/oc_file_cache
```

(6) Give the new drive directory some proper ownership
```bash
sudo chown -R ekansa /mnt/disks/oc-language-model-disk-2026-09-08/oc_data
sudo chown -R ekansa /mnt/disks/oc-language-model-disk-2026-09-08/oc_file_cache
```

(7) Add symlinks so the docker containers can access needed directories in the newly formatted and mounted drive:

```bash
sudo ln -s /mnt/disks/oc-language-model-disk-2026-09-08/oc_data ~/oc-docker/oc_data
sudo ln -s /mnt/disks/oc-language-model-disk-2026-09-08/oc_file_cache ~/oc-docker/oc_file_cache
```
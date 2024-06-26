#!/bin/bash

set -e

trap exit INT TERM

if [ -z "$DOMAINS" ]; then
  echo "DOMAINS environment variable is not set"
  exit 1;
fi

if [ -z "$DOMAINS_WWW" ]; then
  echo "DOMAINS_WWW environment variable is not set"
  exit 1;
fi

until nc -z nginx 80; do
  echo "Waiting for nginx to start..."
  sleep 5s & wait ${!}
done

if [ "$CERTBOT_TEST_CERT" != "0" ]; then
  test_cert_arg="--test-cert"
fi

domains_fixed=$(echo "$DOMAINS" | tr -d \")
domains_www_fixed=$(echo "$DOMAINS_WWW" | tr -d \")
domain_list=($domains_fixed $domains_www_fixed)
emails_fixed=$(echo "$CERTBOT_EMAILS" | tr -d \")
emails_list=($emails_fixed)
for i in "${!domain_list[@]}"; do
  domain="${domain_list[i]}"

  echo "Make cerbot directory for $domain";
  mkdir -p /var/www/certbot/$domain;
  echo "Make the $domain deep directory for acme-challenges";
  mkdir -p /var/www/certbot/$domain/.well-known/acme-challenge;

  if [ -d "/etc/letsencrypt/live/$domain" ]; then
    echo "Let's Encrypt certificate for $domain already exists"
    continue
  fi

  email="${emails_list[i]}"
  if [ -z "$email" ]; then
    email_arg="--register-unsafely-without-email"
    echo "Obtaining the certificate for $domain without email"
  else
    email_arg="--email $email"
    echo "Obtaining the certificate for $domain with email $email"
  fi

  certbot certonly \
    --webroot \
    -w "/var/www/certbot/$domain" \
    -d "$domain" \
    $test_cert_arg \
    $email_arg \
    --rsa-key-size "${CERTBOT_RSA_KEY_SIZE:-4096}" \
    --agree-tos \
    --noninteractive \
    --verbose || true
done

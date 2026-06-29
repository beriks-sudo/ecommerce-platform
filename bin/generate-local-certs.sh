  #!/usr/bin/env bash
  set -euo pipefail

  CERT_DIR="docker/traefik/certs"
  mkdir -p "$CERT_DIR"

  openssl req -x509 -newkey rsa:2048 -nodes \
    -keyout "$CERT_DIR/localho.st.key" \
    -out    "$CERT_DIR/localho.st.crt" \
    -days 365 \
    -subj "/CN=ecommerce.localho.st" \
    -addext "subjectAltName=DNS:ecommerce.localho.st,DNS:*.ecommerce.localho.st"

  echo "✅ Готово:"
  echo "   $CERT_DIR/localho.st.key"
  echo "   $CERT_DIR/localho.st.crt"
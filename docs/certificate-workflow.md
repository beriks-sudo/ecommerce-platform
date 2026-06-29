напиши своими словами: как генерировать сертификаты (make local-certs), что браузер ругается из-за trust (это норма), почему приватный
ключ нельзя в Git.

генерировать вот так  tls:
stores:
default:
defaultCertificate:
certFile: /etc/traefik/certs/localho.st.crt
keyFile: /etc/traefik/certs/localho.st.key

для этого браузеру нужен traefik чтобы не ругатся 

приватный ключ станет не приватным)
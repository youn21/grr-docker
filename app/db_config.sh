#!/usr/bin/env sh

mod=/var/www/html/personnalisation/connect.inc.php
grep -q "{DB_NAME}" "$mod" && sed -i -e "s/{DB_NAME}/$DB_NAME/g" "$mod"
grep -q "{DB_USER}" "$mod" && sed -i -e "s/{DB_USER}/$DB_USER/g" "$mod"
grep -q "{DB_PASSWORD}" "$mod" && sed -i -e "s/{DB_PASSWORD}/$DB_PASSWORD/g" "$mod"

exec "$@"

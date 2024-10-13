#!/usr/bin/env sh

# Helper function
# is_sourced && sourced=1 || sourced=0
 is_sourced() {
   if [ -n "$ZSH_VERSION" ]; then 
       case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
   else  # Add additional POSIX-compatible shell names here, if needed.
       case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
   fi
   return 1  # NOT sourced.
 }
 
init_php_connect() {
  local template=/var/www/html/personnalisation/connect.inc.php.template
  local dest=/var/www/html/personnalisation/connect.inc.php
  cp "$template" "$dest"
  grep -q "{DB_NAME}" "$dest" && sed -i -e "s/{DB_NAME}/$DB_NAME/g" "$dest"
  grep -q "{DB_USER}" "$dest" && sed -i -e "s/{DB_USER}/$DB_USER/g" "$dest"
  grep -q "{DB_PASSWORD}" "$dest" && sed -i -e "s/{DB_PASSWORD}/$DB_PASSWORD/g" "$dest"
}

if ! is_sourced; then
  init_php_connect
  exec "$@"
fi

#!/usr/bin/env bash

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

sql () {
  mariadb --host db \
    --port=3306 \
    --user="${MARIADB_USER}" \
    --ssl-verify-server-cert=false \
    --password="${MARIADB_PASSWORD}" \
    "$@" \
    "${MARIADB_DATABASE}" 
}

patch_migration(){
  local password="$1"
  local file="$2"
  local hashed=$(openssl passwd -6 "$password")
  sed -e "s|VariableInstal05|$hashed|" "$file"
}

db_exists() {
  local tables
  tables=$(cat <<EOF | sql -s
select count(*) from information_schema.tables where table_schema = 'grr';
EOF
        ) && [ "$tables" -gt 0 ]
}


if ! is_sourced; then
  patch_migration "${GRR_ADMIN_PASSWORD}" /etc/init_data/tables.my.sql | sql
  exec "$@"
fi



#!/bin/bash

source .env

if test -z "$1" || test -z "$2"; then
    echo "Usage: $0 <username> <password>"
    echo
    exit 1
fi

new_username="$1"
new_password="$2"
role="superuser"

curl -k -u "elastic:${ELASTIC_PASSWORD}" -X POST "${ELASTIC_URL}/_security/user/${new_username}?pretty" -H 'Content-Type: application/json' -d"
{
  \"password\" : \"${new_password}\",
  \"roles\" : [ \"${role}\" ],
  \"full_name\" : \"${new_username}\",
  \"email\" : \"${new_username}@localhost\"
}
"

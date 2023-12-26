#!/bin/bash
#
#

if ! test -f .env; then
    echo "You need to copy .env.sample to .env, and then edit it"
    echo
    exit 1
fi

cd elastic-bsim
docker build -t elastic-bsim:latest .
cd ..

docker compose up --wait

# Wait 1min for Elasticsearch server to bootstrap
sleep 60

docker compose exec elastic-bsim /usr/share/elasticsearch/bin/elasticsearch-reset-password -b -s -u elastic > elasticpw.txt

ELASTICPW=$(echo -n "$(cat ./elasticpw.txt)")

sed -i "s/ELASTIC_PASSWORD=\".*$/ELASTIC_PASSWORD=\"${ELASTICPW}\"/" .env

source .env

# Download and extract Ghidra
curl -LJ -o ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0_build/ghidra_11.0_PUBLIC_20231222.zip
unzip ghidra.zip
rm ghidra.zip

# Create a new bsim database, using the existing elastic user creds
echo ""
echo "*********"
echo "Note that, below, you'll be prompted for the database password."
echo "The password for this database is: ${ELASTIC_PASSWORD}"
echo "*********"
echo ""

# Perform the database creation step
"${GHIDRA_ROOT}/support/bsim" createdatabase "${ELASTIC_URL}/bsim" medium_nosize "user=elastic" "name=BSim Demo Database"

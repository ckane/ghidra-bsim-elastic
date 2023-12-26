#!/bin/bash

source .env

if test -z "$1" || test -z "$2"; then
    echo "Usage: $0 <projectname> </samples/folder>"
    echo
    exit 1
fi

mkdir -p bsim_projects
mkdir -p bsim_xml

WORKDIR="$(pwd)"
PROJNAME="$1"
SAMPLES="$2"

"${GHIDRA_ROOT}/support/analyzeHeadless" "${WORKDIR}/bsim_projects" "${PROJNAME}" -import "${SAMPLES}" \
    -preScript TailoredAnalysis.java

echo ""
echo "*********"
echo "Note that, below, you'll be prompted for the database password."
echo "The password for this database is: ${ELASTIC_PASSWORD}"
echo "*********"
echo ""

"${GHIDRA_ROOT}/support/bsim" generatesigs "ghidra:${WORKDIR}/bsim_projects/${PROJNAME}" "${WORKDIR}/bsim_xml" \
    "bsim=${ELASTIC_URL}/bsim" "user=elastic" --commit --overwrite

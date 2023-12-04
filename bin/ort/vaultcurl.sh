#!/bin/bash
CA_BUNDLE="$HOME/.dart/dart_root_ca.pem"
VAULT_JSON_FILE="$HOME/.dart/vault.json"
TOKEN=$(python3 -m json.tool $VAULT_JSON_FILE | grep client_token | awk '{print $2}' | sed -e 's/[",]//g')
#USERNAME=$(python3 -m json.tool $VAULT_JSON_FILE | grep client_token | awk '{print $2}' | sed -e 's/[",]//g')

CURL_CA_BUNDLE=${CA_BUNDLE} curl -H "X-Vault-Token: ${TOKEN}" -H "Content-Type: application/json" $@

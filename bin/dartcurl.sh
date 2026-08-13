#!/bin/bash
CA_BUNDLE="$HOME/.dart/dart_root_ca.pem"
TOKEN=$(dart_cli show user --token)

CURL_CA_BUNDLE=${CA_BUNDLE} curl -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" $@

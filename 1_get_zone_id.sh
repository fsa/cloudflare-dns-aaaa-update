#!/bin/bash

if [ -f ".env" ]; then source .env; else exit 1; fi

curl -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json"


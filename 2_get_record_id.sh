#!/bin/bash

if [ -f ".env" ]; then source .env; else exit 1; fi

curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=AAAA&name=$RECORD" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json"


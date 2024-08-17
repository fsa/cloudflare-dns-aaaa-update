#!/bin/sh

INTERFACE_LAN=br-lan

DOMAIN=example.org
RECORD=my_router.example.org
RECORD_VALUE=:1

API_TOKEN=CLOUDFLARE_API_TOKEN
ZONE_ID=ZONE_ID_STEP1
RECORD_ID=RECORD_ID_STEP2

API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"

if [ "$ACTION" = "ifup" ] && [ "$INTERFACE" = "pppoe-wan" ]; then
    IPV6_PREFIX=`ip addr show primary -deprecated -mngtmpaddr to 2000::/3 dev $INTERFACE_LAN | grep inet6 | head -n 1 | tr -s ' ' '\t' | cut -f3 | cut -d'/' -f1 | cut -d':' -f1-4`
    NEW_IPV6=${IPV6_PREFIX}:${RECORD_VALUE}
    $(curl -X PUT "$API_URL" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "AAAA",
       "name": "'"$RECORD"'",
       "content": "'"$NEW_IPV6"'",
       "ttl": 120,
       "proxied": false
     }')
fi
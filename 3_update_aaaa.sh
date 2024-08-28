#!/bin/bash

if [ -f ".env" ]; then source .env; else exit 1; fi

IPV6_PREFIX=`ip -6 addr show scope global primary -deprecated -mngtmpaddr to 2000::/3 dev $INTERFACE | grep inet6 | head -n 1 | tr -s ' ' '\t' | cut -f3 | cut -d'/' -f1 | cut -d':' -f1-4`

NEW_IPV6=${IPV6_PREFIX}:${RECORD_VALUE}

OLD_IPV6=$(dig +short AAAA $RECORD)

if [ "$OLD_IPV6" == "$NEW_IPV6" ]; then
    echo "Адрес не изменился: $OLD_IPV6"
    exit
fi

echo "Новый адрес: $NEW_IPV6"

# Данные для запроса
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"

# Обновление записи AAAA
RESPONSE=$(curl -X PUT "$API_URL" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "AAAA",
       "name": "'"$RECORD"'",
       "content": "'"$NEW_IPV6"'",
       "ttl": 120,
       "proxied": false
     }')

# Проверка ответа API
if echo "$RESPONSE" | grep -q '"success":true'; then
  echo "Запись AAAA успешно обновлена."
else
  echo "Не удалось обновить запись AAAA. Ответ API:"
  echo "$RESPONSE"
fi

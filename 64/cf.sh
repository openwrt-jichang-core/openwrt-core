#!/bin/sh

CF_API_KEY="WwmHgslqyTtf-7efbfASsd0wfuo2FGb-EjrRNWDf"  
ZONE_ID="b6fb85fc007fc746bb81879e696f4ef4"  
DNS_RECORD_NAMES="usz64.333333338.xyz usz65.333333338.xyz usz66.333333338.xyz"  

CURRENT_IP=$(curl -s http://ipv4.icanhazip.com)
if [ -z "$CURRENT_IP" ]; then
  echo "Failed to retrieve current IP address."
  exit 1
fi

echo "Current IP: $CURRENT_IP"

delete_dns_record() {
    local DNS_RECORD_NAME=$1
    echo "Checking if DNS record exists: $DNS_RECORD_NAME"

    RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$DNS_RECORD_NAME" \
        -H "Authorization: Bearer $CF_API_KEY" \
        -H "Content-Type: application/json")

    DNS_RECORD_ID=$(echo "$RESPONSE" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p' | head -n 1)

    if [ -n "$DNS_RECORD_ID" ]; then
        echo "DNS record found for $DNS_RECORD_NAME. Deleting..."

        DELETE_RESPONSE=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
            -H "Authorization: Bearer $CF_API_KEY" \
            -H "Content-Type: application/json")

        if echo "$DELETE_RESPONSE" | grep -q '"success":true'; then
            echo "DNS record $DNS_RECORD_NAME deleted successfully."
        else
            echo "Failed to delete DNS record $DNS_RECORD_NAME. Response: $DELETE_RESPONSE"
        fi
    else
        echo "No existing DNS record found for $DNS_RECORD_NAME."
    fi
}

for DNS_RECORD_NAME in $DNS_RECORD_NAMES; do
    delete_dns_record "$DNS_RECORD_NAME"

    echo "Creating DNS record: $DNS_RECORD_NAME"
    CREATE_PAYLOAD="{\"type\":\"A\",\"name\":\"$DNS_RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":1,\"proxied\":$PROXIED}"
    echo "Payload: $CREATE_PAYLOAD"
    RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $CF_API_KEY" \
        -H "Content-Type: application/json" \
        --data "$CREATE_PAYLOAD")

    echo "Response: $RESPONSE"

    if echo "$RESPONSE" | grep -q '"success":true'; then
        echo "DNS record $DNS_RECORD_NAME created successfully."
    else
        echo "Failed to create DNS record $DNS_RECORD_NAME. Response: $RESPONSE"
    fi
done

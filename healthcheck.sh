#!/bin/bash

# App URL (use public IP or localhost depending on where script runs)
URL="http://13.126.114.47/"

# Recipient email
EMAIL="rajakarthika19@gmail.com"

# Log file
LOG="/tmp/app_health.log"

# Check HTTP status with timeout
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$URL")

# If curl failed completely, set status to 000
if [ -z "$HTTP_STATUS" ]; then
  HTTP_STATUS=000
fi

# If app is down (not 200)
if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "$(date): Application is DOWN (HTTP $HTTP_STATUS)" >> "$LOG"
    echo "Application is DOWN on $(hostname) (HTTP $HTTP_STATUS)" | mail -s "App Down Alert" "$EMAIL"
else
    echo "$(date): Application is UP" >> "$LOG"
fi

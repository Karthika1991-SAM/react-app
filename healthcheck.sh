#!/bin/bash

# App URL
URL="http://localhost"   # Or http://<EC2_PUBLIC_IP> if remote

# Recipient email
EMAIL="rajakarthika19@gmail.com"

# Log file
LOG="/tmp/app_health.log"

# Check HTTP status
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

# If app is down (not 200)
if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "$(date): Application is DOWN (HTTP $HTTP_STATUS)" >> $LOG
    echo "Application is DOWN on $(hostname) (HTTP $HTTP_STATUS)" | mail -s "App Down Alert" $EMAIL
else
    echo "$(date): Application is UP" >> $LOG
fi

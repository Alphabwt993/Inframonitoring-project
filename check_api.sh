#!/bin/bash

if [ -z "$1" ]; then
	echo "Не указан URL API."
	echo "Использование: $0 <URL>"
	exit 1
fi

URL="$1"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
	echo "API доступен"
	exit 0
else
	echo "API недоступен, код ответа: $HTTP_STATUS"
	exit 1
fi

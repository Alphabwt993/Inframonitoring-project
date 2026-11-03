#!/bin/bash

LOG_FILE="access.log"

generate_test_log() {
    echo "=== Генерация тестового файла $LOG_FILE ==="
    > "$LOG_FILE" 

    IPS=("192.168.1.10" "10.0.0.5" "172.16.0.1" "8.8.8.8" "1.1.1.1" "203.0.113.5")
    METHODS=("GET" "POST" "PUT" "DELETE")
    ENDPOINTS=("/api/users" "/api/login" "/api/products" "/api/orders" "/api/v1/data")
    STATUSES=(200 201 301 400 401 403 404 500 502)

    for i in {1..350}; do
        IP=${IPS[$RANDOM % ${#IPS[@]}]}
        METHOD=${METHODS[$RANDOM % ${#METHODS[@]}]}
        ENDPOINT=${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}
        STATUS=${STATUSES[$RANDOM % ${#STATUSES[@]}]}
        TIME=$(date -d "-$((RANDOM % 1000)) minutes" +"[%d/%b/%Y:%H:%M:%S]")

        echo "$IP - - $TIME \"$METHOD $ENDPOINT HTTP/1.1\" $STATUS" >> "$LOG_FILE"
    done
    echo "Успешно создано $(wc -l < "$LOG_FILE") строк лога."
    echo ""
}

analyze_log() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "Ошибка: Файл $LOG_FILE не найден."
        exit 1
    fi

    echo "=== Результаты анализа ==="
   
    echo "1. Общее количество запросов:"
    awk 'END {print NR}' "$LOG_FILE"
    echo ""

    echo "2. Топ-3 IP-адреса с наибольшим числом запросов:"
    grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 3
    echo ""

    echo "3. Количество запросов с кодами 4xx и 5xx:"
    awk '$NF ~ /^[45][0-9]{2}$/ {count++} END {print count+0}' "$LOG_FILE"
    echo ""
}

generate_test_log
analyze_log

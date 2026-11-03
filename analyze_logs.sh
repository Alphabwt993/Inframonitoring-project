#!/bin/bash

LOG_FILE="access.log"

# Функция генерации тестового файла
generate_test_log() {
    echo "=== Генерация тестового файла $LOG_FILE ==="
    > "$LOG_FILE" # Очищаем файл перед записью, если он существует

    # Массивы для случайной генерации данных
    IPS=("192.168.1.10" "10.0.0.5" "172.16.0.1" "8.8.8.8" "1.1.1.1" "203.0.113.5")
    METHODS=("GET" "POST" "PUT" "DELETE")
    ENDPOINTS=("/api/users" "/api/login" "/api/products" "/api/orders" "/api/v1/data")
    STATUSES=(200 201 301 400 401 403 404 500 502)

    # Генерируем 350 строк (больше требуемых 300)
    for i in {1..350}; do
        IP=${IPS[$RANDOM % ${#IPS[@]}]}
        METHOD=${METHODS[$RANDOM % ${#METHODS[@]}]}
        ENDPOINT=${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}
        STATUS=${STATUSES[$RANDOM % ${#STATUSES[@]}]}
       
        # Генерируем случайное время (в пределах последних 1000 минут)
        TIME=$(date -d "-$((RANDOM % 1000)) minutes" +"[%d/%b/%Y:%H:%M:%S]")

        # Записываем строку в формате: IP - - [Date] "Method Path HTTP/1.1" Status
        echo "$IP - - $TIME \"$METHOD $ENDPOINT HTTP/1.1\" $STATUS" >> "$LOG_FILE"
    done
    echo "Успешно создано $(wc -l < "$LOG_FILE") строк лога."
    echo ""
}

# Функция анализа логов
analyze_log() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "Ошибка: Файл $LOG_FILE не найден."
        exit 1
    fi

    echo "=== Результаты анализа ==="
   
    # 1. Общее количество запросов
    echo "1. Общее количество запросов:"
    awk 'END {print NR}' "$LOG_FILE"
    echo ""

    # 2. Топ-3 IP-адреса (используем регулярное выражение для парсинга)
    echo "2. Топ-3 IP-адреса с наибольшим числом запросов:"
    # Извлекаем только IP с помощью regex, сортируем, считаем уникальные, сортируем по убыванию, берем топ-3
    grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 3
    echo ""

    # 3. Количество запросов с кодами 4xx и 5xx
    echo "3. Количество запросов с кодами 4xx и 5xx:"
    # $NF (последнее поле) — это код ответа. Проверяем его через регулярное выражение.
    awk '$NF ~ /^[45][0-9]{2}$/ {count++} END {print count+0}' "$LOG_FILE"
    echo ""
}

# --- Запуск скрипта ---
generate_test_log
analyze_log

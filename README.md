# Inframonitoring-project
# Проект автоматизации мониторинга и анализа логов

##  Инструкция по деплою на удаленный сервер (SSH и SCP)

Для безопасного развертывания проекта на удаленном сервере выполните следующие шаги.

### 1. Генерация и настройка SSH-ключей
Если у вас еще нет SSH-ключей, сгенерируйте их на локальной машине:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
*Нажимайте `Enter`, чтобы сохранить путь по умолчанию.*

Скопируйте ваш публичный ключ на удаленный сервер для беспарольного доступа:
```bash
ssh-copy-id username@remote_server_ip
```

### 2. Подготовка и передача файлов проекта
Создайте архив проекта на локальной машине:
```bash
tar -czf project.tar.gz check_api.sh analyze_logs.sh docker-compose.yml nginx.conf README.md
```

Передайте архив на удаленный сервер через утилиту `scp`:
```bash
scp project.tar.gz username@remote_server_ip:/home/username/
```

### 3. Развертывание проекта на сервере
Подключитесь к серверу по SSH:
```bash
ssh username@remote_server_ip
```

Распакуйте архив и перейдите в директорию проекта:
```bash
mkdir -p infra-monitoring-project 
tar -xzf project.tar.gz -C infra-monitoring-project
cd infra-monitoring-project
```

Запустите мониторинг-стек через Docker Compose:
```bash
docker compose up -d
```

### 4. Проверка работы скриптов на сервере
Сделайте скрипты исполняемыми и запустите их для проверки:
```bash
chmod +x check_api.sh analyze_logs.sh
./check_api.sh URL
./check_api.sh URL/status/XXX
./analyze_logs.sh
```

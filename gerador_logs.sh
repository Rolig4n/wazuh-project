#!/bin/sh
# Arquivo onde os logs serão gravados
LOG_FILE="/var/log/ameacas_simuladas.log"
touch $LOG_FILE
echo "Iniciando simulador de ameaças..." >> $LOG_FILE

while true; do
    DATA=$(date "+%b %d %H:%M:%S")
    
    # Simulação 1: Falha de login SSH (Ataque de Força Bruta)
    echo "\(DATA endpoint-docker sshd[1337]: Failed password for root from 192.168.1.100 port 44322 ssh2" >>\)LOG_FILE
    
    # Simulação 2: Tentativa de SQL Injection em servidor Web
    echo "\(DATA endpoint-docker nginx: 192.168.1.20 - - [\)DATA] \"GET /login.php?user=admin' OR '1'='1 HTTP/1.1\" 403 123" >> $LOG_FILE
    
    # Simulação 3: Execução de comando restrito com falha de senha (Escalonamento de Privilégio)
    echo "\(DATA endpoint-docker sudo: hacker : 3 incorrect password attempts ; TTY=pts/0 ; PWD=/tmp ; USER=root ; COMMAND=/bin/cat /etc/shadow" >>\)LOG_FILE

    # Aguarda entre 3 e 7 segundos antes de gerar os próximos logs
    sleep $(( (RANDOM % 5) + 3 ))
done
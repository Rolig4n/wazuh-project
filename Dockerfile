# Usa o Alpine Linux por ser extremamente leve
FROM alpine:latest

# Copia o script para dentro do container
COPY gerador_logs.sh /gerador_logs.sh

# Remove as quebras de linha do Windows (CRLF para LF) e dá permissão
# Dá permissão de execução ao script
RUN sed -i 's/\r$//' /gerador_logs.sh && \
    chmod +x /gerador_logs.sh

# Executa o script quando o container iniciar
CMD ["/gerador_logs.sh"]
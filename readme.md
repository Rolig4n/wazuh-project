# Guia de Simulação de Ameaças com Docker e Wazuh Agent (Ambiente Windows)

Este guia detalha os passos para criar um container Docker leve que gera logs falsos (simulando ataques) e como configurar o Agente do Wazuh no Windows para ler e enviar esses logs para o painel SIEM/XDR.

## Pré-requisitos
*   **Docker Desktop** instalado e rodando no Windows.
*   **Wazuh Agent** instalado e registrado no seu servidor Wazuh.
*   Editor de texto (como Bloco de Notas ou VS Code).

---

## Passo 1: Criar os arquivos do container

Crie uma pasta no seu computador para o projeto (por exemplo, `C:\wazuh-simulador`). Dentro dela, crie os dois arquivos abaixo:

### 1. Construir e rodar o Container

Abra o **Prompt de Comando (CMD)** ou **PowerShell**, navegue até a pasta onde você criou os arquivos e execute:

1. **Construir a imagem:**
   ```bash
   docker build -t simulador-wazuh .
   ```

2. **Iniciar o container mapeando o volume:**
   O comando abaixo vai criar uma pasta `logs_simulados` na raiz do seu disco C e salvar os logs gerados pelo container nela.
   ```bash
   docker run -d --name container-simulador -v C:\logs_simulados:/var/log simulador-wazuh
   ```

---

## Passo 2: Configurar o Wazuh Agent (Windows)

Agora precisamos dizer ao agente do Wazuh para monitorar a pasta onde o container está salvando os logs.

1. Abra o **Bloco de Notas como Administrador**.
2. Vá em Arquivo > Abrir e navegue até: `C:\Program Files (x86)\ossec-agent\ossec.conf`
3. Role o arquivo para baixo até encontrar a seção `<ossec_config>`. Adicione o seguinte bloco de código dentro dessa seção (preferencialmente perto de outros blocos `<localfile>` se houver):

   ```xml
   <localfile>
     <log_format>syslog</log_format>
     <location>C:\logs_simulados\ameacas_simuladas.log</location>
   </localfile>
   ```
4. Salve e feche o arquivo.

---

## Passo 3: Reiniciar o Agente do Wazuh

Para que o agente leia a nova configuração, ele precisa ser reiniciado.

Abra o **PowerShell como Administrador** e execute o seguinte comando:
```powershell
Restart-Service -Name WazuhSvc
```
*(Alternativa: Você pode reiniciar o serviço "Wazuh" pelo menu "Serviços" do Windows).*

---

## Verificação

1. **No seu computador:** Verifique se o arquivo `C:\logs_simulados\ameacas_simuladas.log` está sendo populado com novos erros a cada poucos segundos.
2. **No painel do Wazuh:** Acesse a aba **Security events** e procure pelos alertas de *SSH authentication failed*, *SQL Injection* e *violações do Sudo*.
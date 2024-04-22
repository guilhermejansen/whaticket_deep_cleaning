# 🚀 Setup Automatizado - Whaticket Deep Cleaning

Este projeto inclui um script de instalação automatizado para configurar a aplicação Whaticket Deep Cleaning, garantindo a limpeza e o backup eficientes de arquivos antigos em armazenamentos locais e em nuvem utilizando MinIO S3.

## 📁 Lógica de Processamento dos Diretórios das Companhias

A aplicação Whaticket Deep Cleaning foi projetada para lidar com diretórios de companhias de forma individualizada, garantindo que cada companhia tenha seus arquivos processados de maneira isolada e segura.

### Estrutura de Diretórios

Cada companhia possui seu próprio diretório dentro do diretório principal `public`. O nome de cada diretório de companhia corresponde ao seu `companyId`, por exemplo:

- `/home/deploy/whaticket/backend/public/company1`
- `/home/deploy/whaticket/backend/public/company14`

### Processamento Individualizado

Quando a rotina de limpeza é acionada, a aplicação percorre cada diretório de companhia dentro de `public`. Para cada diretório encontrado, a aplicação executa as seguintes ações:

1. **Verificação de Arquivos Antigos:** A aplicação verifica se existem arquivos dentro do diretório da companhia que excedem o tempo de retenção configurado.
2. **Backup e Envio via Webhook (Se Habilitado):** Se o webhook estiver habilitado e houver arquivos antigos, a aplicação compacta esses arquivos em um arquivo `.zip`, nomeando o arquivo zip com o `companyId` correspondente. O arquivo zip é então enviado para o webhook configurado.
3. **Envio para MinIO S3 (Se Habilitado):** Se a integração com S3 estiver habilitada, o arquivo zip também é enviado para o bucket S3 configurado para armazenamento seguro e de longo prazo.
4. **Exclusão de Arquivos:** Após a confirmação de sucesso nos envios, os arquivos originais são excluídos do diretório da companhia.

### Tentativas de Envio para o Webhook e MinIO S3

Se o envio do backup para o webhook ou para o MinIO S3 falhar, a aplicação tentará reenviar o backup mais 3 vezes antes de desistir e passar para o próximo diretório de companhia.

## 📋 Etapas de Instalação

### Iniciar o script de instalação

Para iniciar a instalação, execute o script `install.sh` no terminal. Você pode precisar dar permissão de execução ao script com o seguinte comando:

```bash
chmod +x install.sh
./install.sh
```

Permissões das Pastas
Para que a automação funcione corretamente, é necessário garantir que o usuário sob o qual o servidor está executando tenha permissões adequadas para ler e escrever no diretório public. Isso pode ser configurado com o seguinte comando:

```bash
chown -R deploy:deploy /home/deploy/whaticket/backend/public
chmod -R 775 /home/deploy/whaticket/backend/public
```

Troque deploy_user e deploy_group pelo usuário e grupo apropriados que estão executando o processo do servidor.

### 2. **Opções do Menu**

- **Instalar Aplicação:** Clona o repositório e realiza a instalação e configuração inicial.
- **Configurar Tempo de Retenção de Arquivos:** Permite especificar o período de retenção.
- **Configurar Webhook:** Configura a URL do webhook para os backups.
- **Configurar MinIO S3:** Permite configurar as credenciais e o endpoint para o MinIO S3.
- **Sair:** Encerra o script.

### 3. **Configuração Inicial**

Durante a instalação, o usuário tem a opção de configurar:
- **Tempo de retenção padrão:** 6 meses.
- **URL do webhook padrão:** Deve ser substituída por uma URL válida.
- **Credenciais MinIO S3:** Incluindo access key, secret key e endpoint.

### 4. **Instalação de Dependências e Configuração do PM2**

- As dependências são instaladas e o `pm2` é configurado para manter a aplicação em execução.

## 🛡️ Notas Adicionais

- **Segurança do Webhook:** Recomenda-se usar HTTPS.
- **Monitoramento de Diretórios:** A aplicação verifica regularmente os arquivos que excedem o tempo de retenção.

## 🌟 Exemplos de Resultados

### Webhook Response
![Webhook Response](https://github.com/guilhermejansen/whaticket_deep_cleaning/blob/main/n8nwebhook.png)

### MinIO S3 Upload
![MinIO S3 Upload](https://github.com/guilhermejansen/whaticket_deep_cleaning/blob/main/minios3.png)

## 📚 Configuração de .env para Funcionamento do Sistema

As seguintes variáveis devem ser configuradas no arquivo `.env` para o correto funcionamento da aplicação:

```plaintext
RETENTION_TIME=3  # Tempo em meses para a retenção de arquivos
PUBLIC_DIR=/home/deploy/whaticket/backend/public  # Diretório público de arquivos
WEBHOOK_URL=http://webhook.com  # URL do webhook para envio dos backups
WEBHOOK_ENABLED=true  # Ativação do envio para webhook
MINIO_ACCESS_KEY=vYkuBrFbHS  # Chave de acesso ao MinIO S3
MINIO_SECRET_KEY=Xlc5kcU2rHBBwsTEOvYiiDe  # Chave secreta do MinIO S3
MINIO_ENDPOINT=https://s3.exemplo.com  # Endpoint do MinIO S3
S3_BUCKET_NAME=whaticket  # Nome do bucket no MinIO S3
S3_ENABLED=true  # Ativação do envio para MinIO S3

---

[![Coffee QR Code](https://github.com/guilhermejansen/whaticket_deep_cleaning/raw/main/coffee-qrcode.png)](https://www.paypal.com/donate?hosted_button_id=K7YAM48FD4Y3Y)

<a href="https://www.paypal.com/donate?hosted_button_id=K7YAM48FD4Y3Y" target="_blank"><img src="https://www.paypalobjects.com/pt_BR/BR/i/btn/btn_donateCC_LG.gif" border="0" alt="Donate with PayPal"></a>


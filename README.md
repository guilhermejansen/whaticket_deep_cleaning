# 🚀 Setup Automatizado - Whaticket Deep Cleaning

Este projeto inclui um script de instalação automatizado para configurar a aplicação Whaticket Deep Cleaning, garantindo a limpeza e o backup eficientes de arquivos antigos.

## 📋 Etapas de Instalação

### 1. **Verificar e Instalar Git (se necessário)**

- O script verifica a presença do `git` no sistema, essencial para clonar o repositório do projeto.
- Caso o `git` não esteja instalado, o script tentará instalá-lo automaticamente usando `apt-get`. Se você estiver em um sistema diferente de Debian/Ubuntu, pode ser necessário ajustar este passo.

### 2. **Opções do Menu**

- **Instalar Aplicação:** Clona o repositório e realiza a instalação e configuração inicial, incluindo o tempo de retenção de arquivos e a URL do webhook.
- **Configurar Tempo de Retenção de Arquivos:** Permite especificar o período máximo que os arquivos podem permanecer no diretório antes de serem excluídos.
- **Configurar Webhook:** Configura a URL do webhook para onde os backups dos arquivos serão enviados antes da exclusão.
- **Sair:** Encerra o script.

### 3. **Configuração Inicial**

- Durante a instalação, o usuário tem a opção de configurar o tempo de retenção e a URL do webhook. Se omitido, serão utilizados valores padrão.
- O **tempo de retenção** padrão é de 6 meses.
- A **URL do webhook** padrão é um exemplo e deve ser substituída por uma URL válida para o envio dos backups.

### 4. **Instalação de Dependências e Configuração do PM2**

- Após a configuração inicial, as dependências necessárias são instaladas usando `npm install`.
- O `pm2` é configurado para iniciar a aplicação automaticamente, mantendo-a em execução em segundo plano e garantindo a reinicialização automática após reinícios do sistema.

## 🛡️ Notas Adicionais

- **Segurança do Webhook:** Use HTTPS para garantir a segurança dos dados transmitidos.
- **Monitoramento de Diretórios:** A aplicação verifica regularmente os arquivos que excedem o tempo de retenção configurado e os processa conforme necessário.
- **Customização:** As configurações de tempo de retenção e URL do webhook podem ser ajustadas editando o arquivo `.env` ou usando as opções relevantes no menu do script de instalação.

Siga estas etapas para configurar a aplicação e manter seus diretórios limpos e seguros, com backups automáticos de arquivos importantes antes da exclusão. 🌟

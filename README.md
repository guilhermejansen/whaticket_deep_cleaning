# 🚀 Setup Automatizado - Whaticket Deep Cleaning

Este projeto inclui um script de instalação automatizado para configurar a aplicação Whaticket Deep Cleaning, garantindo a limpeza e o backup eficientes de arquivos antigos.

## 📁 Lógica de Processamento dos Diretórios das Companhias

A aplicação Whaticket Deep Cleaning foi projetada para lidar com diretórios de companhias de forma individualizada, garantindo que cada companhia tenha seus arquivos processados de maneira isolada e segura.

### Estrutura de Diretórios

Cada companhia possui seu próprio diretório dentro do diretório principal `public`. O nome de cada diretório de companhia corresponde ao seu `companyId`, por exemplo:

- `/home/deploy/multi100/backend/public/company1`
- `/home/deploy/multi100/backend/public/company14`

Essa estrutura permite que a aplicação identifique e trate cada conjunto de arquivos de forma independente, associando-os à companhia correta.

### Processamento Individualizado

Quando a rotina de limpeza é acionada, a aplicação percorre cada diretório de companhia dentro de `public`. Para cada diretório encontrado, a aplicação executa as seguintes ações:

1. **Verificação de Arquivos Antigos:** A aplicação verifica se existem arquivos dentro do diretório da companhia que excedem o tempo de retenção configurado. Esse tempo de retenção é definido globalmente mas aplicado individualmente a cada companhia.

2. **Backup e Envio via Webhook (Se Habilitado):** Se o webhook estiver habilitado e houver arquivos antigos, a aplicação compacta esses arquivos em um arquivo `.zip`, nomeando o arquivo zip com o `companyId` correspondente. O arquivo zip é então enviado para o webhook configurado.

3. **Exclusão de Arquivos:** Após a confirmação de sucesso no envio do backup via webhook, os arquivos originais são excluídos do diretório da companhia, liberando espaço e mantendo a organização dos dados.

### Tentativas de Envio para o Webhook

Se o envio do backup para o webhook falhar, a aplicação tentará reenviar o backup mais 3 vezes antes de desistir e passar para o próximo diretório de companhia. Essa resiliência garante que problemas temporários de rede ou no servidor do webhook não impeçam a conclusão do processo de limpeza.

Ao seguir essa lógica, a aplicação Whaticket Deep Cleaning assegura uma gestão eficiente e automatizada dos arquivos das companhias, mantendo os dados seguros e o sistema organizado.

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

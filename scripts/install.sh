#!/bin/bash

# Limpa a tela antes de mostrar a logo
clear

# Exibe a logo com o texto "SETUP AUTOMATIZADO" em azul
echo -e "\e[34m"  # Inicia a cor azul
echo "███████╗███████╗████████╗██╗   ██╗██████╗ "
echo "██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
echo "███████╗█████╗     ██║   ██║   ██║██████╔╝"
echo "╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
echo "███████║███████╗   ██║   ╚██████╔╝██║     "
echo "╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
echo "                                         "
echo "      S E T U P   A U T O M A T I Z A D O"
printf "%60s\n" "by Guilherme Jansen"
echo -e "\e[0m"

# Continua com o restante do script
echo "Bem-vindo ao Instalador da Limpeza de Arquivos do Diretório do Whaticket SaaS!"
# Diretório onde o projeto será instalado
PROJECT_DIR="whaticket_deep_cleaning"

# Valores padrão para configurações
DEFAULT_RETENTION_TIME=6  # Tempo de retenção padrão em meses
DEFAULT_WEBHOOK_URL="http://example.com/webhook"  # URL do webhook padrão

# Mensagem de boas-vindas
echo "Bem-vindo ao Instalador da Limpeza de Arquivos"
echo "1. Instalar Aplicação"
echo "2. Configurar Tempo de Retenção de Arquivos"
echo "3. Configurar Webhook"
echo "4. Sair"

# Solicitar a escolha do usuário
read -p "Escolha uma opção: " option

case $option in
  1)
    # Verificar e instalar Git, se necessário
    echo "Verificando e instalando Git se necessário..."
    if ! command -v git &> /dev/null; then
        echo "Git não encontrado. Tentando instalar..."
        sudo apt-get update && sudo apt-get install -y git
    else
        echo "Git já está instalado."
    fi

    # Clone do repositório e instalação da aplicação
    echo "Instalando a aplicação..."
    git clone https://github.com/guilhermejansen/whaticket_deep_cleaning.git $PROJECT_DIR
    cd $PROJECT_DIR

    # Opção para configurar tempo de retenção e webhook agora
    echo "Você deseja configurar o tempo de retenção e o webhook agora? (s/n)"
    read -p "Escolha uma opção: " configure_now

    if [[ "$configure_now" == "s" ]]; then
      read -p "Digite o tempo de retenção de arquivos em meses (Padrão: $DEFAULT_RETENTION_TIME): " retention_time
      read -p "Digite a URL do webhook (Padrão: $DEFAULT_WEBHOOK_URL): " webhook_url

      # Usar valores padrão se nenhuma entrada for fornecida
      retention_time=${retention_time:-$DEFAULT_RETENTION_TIME}
      webhook_url=${webhook_url:-$DEFAULT_WEBHOOK_URL}
    else
      # Usar valores padrão se o usuário optar por não configurar agora
      retention_time=$DEFAULT_RETENTION_TIME
      webhook_url=$DEFAULT_WEBHOOK_URL
    fi

    # Salvar as configurações no arquivo .env
    echo "Salvando configurações..."
    echo "RETENTION_TIME=$retention_time" > .env
    echo "WEBHOOK_URL=$webhook_url" >> .env

    # Instalar dependências do projeto
    echo "Instalando dependências..."
    npm install

    # Configurar PM2 para manter a aplicação rodando
    echo "Configurando PM2 para manter a aplicação rodando em segundo plano..."
    pm2 start dist/index.js --name whaticket_deep_cleaning
    pm2 save
    pm2 startup

    echo "Aplicação instalada e configurada para iniciar automaticamente após o boot do sistema."
    ;;

  2)
    # Configuração do tempo de retenção de arquivos
    cd $PROJECT_DIR
    echo "Configurando Tempo de Retenção de Arquivos..."
    read -p "Digite o tempo de retenção de arquivos em meses: " retention_time

    # Atualizar .env com o novo valor
    echo "Atualizando tempo de retenção..."
    if [ -f ".env" ]; then
      sed -i "/RETENTION_TIME=/c\RETENTION_TIME=$retention_time" .env
    else
      echo "RETENTION_TIME=$retention_time" > .env
    fi
    ;;

  3)
    # Configuração do webhook
    cd $PROJECT_DIR
    echo "Configurando Webhook..."
    read -p "Digite a URL do webhook: " webhook_url

    # Atualizar .env com o novo valor
    echo "Atualizando URL do webhook..."
    if [ -f ".env" ]; then
      sed -i "/WEBHOOK_URL=/c\WEBHOOK_URL=$webhook_url" .env
    else
      echo "WEBHOOK_URL=$webhook_url" > .env
    fi
    ;;

  4)
    # Sair do script
    echo "Saindo do instalador..."
    exit 0
    ;;
  *)
    # Opção inválida
    echo "Opção inválida."
    ;;
esac

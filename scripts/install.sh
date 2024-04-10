#!/bin/bash

clear

echo -e "\e[34m" 
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

echo "Bem-vindo ao Instalador da Limpeza de Arquivos do Diretório do Whaticket SaaS!"
echo "1. Instalar Aplicação"
echo "2. Configurar Tempo de Retenção de Arquivos"
echo "3. Configurar Webhook"
echo "4. Sair"

read -p "Escolha uma opção: " option

PROJECT_DIR="whaticket_deep_cleaning"

DEFAULT_RETENTION_TIME=6
DEFAULT_WEBHOOK_URL="http://example.com/webhook"

case $option in
  1)

    echo "Verificando e instalando Git se necessário..."
    if ! command -v git &> /dev/null; then
        echo "Git não encontrado. Tentando instalar..."
        sudo apt-get update && sudo apt-get install -y git
    else
        echo "Git já está instalado."
    fi

    echo "Instalando a aplicação..."
    git clone https://github.com/guilhermejansen/whaticket_deep_cleaning.git $PROJECT_DIR
    cd $PROJECT_DIR

    echo "Você deseja ativar o webhook para backup dos arquivos? (s/n)"
    read -p "Escolha uma opção: " webhook_enabled

    webhook_enabled=${webhook_enabled,,}

    if [[ "$webhook_enabled" == "s" ]]; then
      read -p "Digite a URL do webhook: " webhook_url
      echo "WEBHOOK_ENABLED=true" > .env
      echo "WEBHOOK_URL=$webhook_url" >> .env
    else
      echo "WEBHOOK_ENABLED=false" > .env
    fi

    echo "Salvando configurações..."
    echo "RETENTION_TIME=$DEFAULT_RETENTION_TIME" >> .env

    echo "Instalando dependências..."
    npm install

    echo "Configurando PM2 para manter a aplicação rodando em segundo plano..."
    pm2 start dist/index.js --name whaticket_deep_cleaning
    pm2 save
    pm2 startup

    echo "Aplicação instalada e configurada para iniciar automaticamente após o boot do sistema."
    ;;

  2)

    cd $PROJECT_DIR
    echo "Configurando Tempo de Retenção de Arquivos..."
    read -p "Digite o tempo de retenção de arquivos em meses: " retention_time

    echo "Atualizando tempo de retenção..."
    if [ -f ".env" ]; then
      sed -i "/RETENTION_TIME=/c\RETENTION_TIME=$retention_time" .env
    else
      echo "RETENTION_TIME=$retention_time" > .env
    fi
    ;;

  3)
    cd $PROJECT_DIR
    echo "Configurando Webhook..."
    read -p "Digite a URL do webhook: " webhook_url

    echo "Atualizando URL do webhook..."
    if [ -f ".env" ]; then
      sed -i "/WEBHOOK_URL=/c\WEBHOOK_URL=$webhook_url" .env
    else
      echo "WEBHOOK_URL=$webhook_url" >> .env
    fi
    ;;

  4)

    echo "Saindo do instalador..."
    exit 0
    ;;
  *)

    echo "Opção inválida."
    ;;
esac

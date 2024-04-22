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
printf "%60s\n" "by Guilherme Jansen - Web Developer"
echo -e "\e[0m"

echo "Bem-vindo ao Instalador da Limpeza de Arquivos do Diretório do Whaticket SaaS!"
echo "1. Instalar Aplicação"
echo "2. Configurar Tempo de Retenção de Arquivos"
echo "3. Configurar Webhook"
echo "4. Configurar MinIO S3"
echo "5. Sair"

read -p "Escolha uma opção: " option

PROJECT_DIR="whaticket_deep_cleaning"
DEFAULT_PUBLIC_DIR="/home/deploy/whaticket/backend/public"
DEFAULT_RETENTION_TIME=6
DEFAULT_WEBHOOK_URL="http://example.com/webhook"
DEFAULT_MINIO_ENDPOINT="https://s3.example.com"
DEFAULT_MINIO_ACCESS_KEY="your_access_key"
DEFAULT_MINIO_SECRET_KEY="your_secret_key"
DEFAULT_S3_BUCKET_NAME="whaticket"

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

    cp .env.exemplo .env
    echo "Arquivo de configuração .env criado a partir de .env.exemplo."

    echo "Você deseja ativar o webhook para backup dos arquivos? (s/n)"
    read -p "Escolha uma opção: " webhook_enabled
    webhook_enabled=${webhook_enabled,,}
    webhook_enabled=$( [[ "$webhook_enabled" == "s" ]] && echo "true" || echo "false" )

    echo "Você deseja ativar o backup no MinIO S3? (s/n)"
    read -p "Escolha uma opção: " s3_enabled
    s3_enabled=${s3_enabled,,}
    s3_enabled=$( [[ "$s3_enabled" == "s" ]] && echo "true" || echo "false" )

    echo "WEBHOOK_ENABLED=$webhook_enabled" > .env
    echo "S3_ENABLED=$s3_enabled" >> .env
    echo "RETENTION_TIME=$DEFAULT_RETENTION_TIME" >> .env
    echo "PUBLIC_DIR=$DEFAULT_PUBLIC_DIR" >> .env

    if [[ "$webhook_enabled" == "true" ]]; then
      read -p "Digite a URL do webhook: " webhook_url
      echo "WEBHOOK_URL=${webhook_url:-$DEFAULT_WEBHOOK_URL}" >> .env
    fi

    if [[ "$s3_enabled" == "true" ]]; then
      read -p "Digite o endpoint do MinIO S3: " minio_endpoint
      read -p "Digite a access key do MinIO S3: " minio_access_key
      read -p "Digite a secret key do MinIO S3: " minio_secret_key
      read -p "Digite o nome do bucket S3: " s3_bucket_name
      echo "MINIO_ENDPOINT=${minio_endpoint:-$DEFAULT_MINIO_ENDPOINT}" >> .env
      echo "MINIO_ACCESS_KEY=${minio_access_key:-$DEFAULT_MINIO_ACCESS_KEY}" >> .env
      echo "MINIO_SECRET_KEY=${minio_secret_key:-$DEFAULT_MINIO_SECRET_KEY}" >> .env
      echo "S3_BUCKET_NAME=${s3_bucket_name:-$DEFAULT_S3_BUCKET_NAME}" >> .env
    fi

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
    sed -i "/RETENTION_TIME=/c\RETENTION_TIME=$retention_time" .env
    ;;

  3)
    cd $PROJECT_DIR
    echo "Configurando Webhook..."
    read -p "Digite a URL do webhook: " webhook_url
    echo "Atualizando URL do webhook..."
    sed -i "/WEBHOOK_URL=/c\WEBHOOK_URL=$webhook_url" .env
    ;;

  4)
    cd $PROJECT_DIR
    echo "Configurando MinIO S3..."
    read -p "Digite o endpoint do MinIO S3: " minio_endpoint
    read -p "Digite a access key do MinIO S3: " minio_access_key
    read -p "Digite a secret key do MinIO S3: " minio_secret_key
    read -p "Digite o nome do bucket S3: " s3_bucket_name
    echo "Atualizando configurações do MinIO S3..."
    sed -i "/MINIO_ENDPOINT=/c\MINIO_ENDPOINT=$minio_endpoint" .env
    sed -i "/MINIO_ACCESS_KEY=/c\MINIO_ACCESS_KEY=$minio_access_key" .env
    sed -i "/MINIO_SECRET_KEY=/c\MINIO_SECRET_KEY=$minio_secret_key" .env
    sed -i "/S3_BUCKET_NAME=/c\S3_BUCKET_NAME=$s3_bucket_name" .env
    ;;

  5)
    echo "Saindo do instalador..."
    exit 0
    ;;
  *)
    echo "Opção inválida."
    ;;
esac

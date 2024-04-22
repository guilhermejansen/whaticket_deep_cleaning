#!/bin/bash

# Habilitando o modo de depuração para ver cada comando antes de sua execução
set -x

# Definindo o diretório base novo
NEW_BASE_DIR="/home/deploy/whaticket/backend/public"

# Definindo o diretório base antigo
OLD_BASE_DIR="/root/backend/public"

# Verificando e criando o diretório raiz (/multi100/backend), se necessário
if [ ! -d "/home/deploy/whaticket/backend" ]; then
  echo "Diretório /home/deploy/whaticket/backend não existe. Criando diretório..."
  mkdir -p "/home/deploy/whaticket/backend"
  if [ $? -ne 0 ]; then
    echo "Erro ao criar o diretório base /home/deploy/whaticket/backend. Verifique as permissões." >&2
    exit 1
  else
    echo "Diretório base /home/deploy/whaticket/backend criado com sucesso."
  fi
fi

# Criando o diretório base para as pastas das companhias, se não existir
mkdir -p "$NEW_BASE_DIR"
if [ $? -ne 0 ]; then
  echo "Erro ao criar o diretório $NEW_BASE_DIR. Verifique as permissões." >&2
  exit 1
else
  echo "Diretório $NEW_BASE_DIR criado com sucesso."
fi

# Loop para criar 10 pastas de companhias
for i in {1..10}; do
  COMPANY_DIR="$NEW_BASE_DIR/company$i"
  mkdir -p "$COMPANY_DIR"
  if [ $? -ne 0 ]; then
    echo "Erro ao criar o diretório da companhia em $COMPANY_DIR. Verifique as permissões." >&2
    continue  # Continua com o próximo diretório em caso de falha
  else
    echo "Diretório $COMPANY_DIR criado com sucesso."
  fi
  
chown -R root:root $NEW_BASE_DIR  # Trocar 'root' pelo usuário apropriado se necessário
chmod -R 777 $NEW_BASE_DIR  # Considere usar 755 para diretórios e 644 para arquivos se a segurança for uma preocupação

  # Dentro de cada pasta da companhia, criar 10 arquivos de texto
  for j in {1..10}; do
    FILE_TXT="$COMPANY_DIR/file$j.txt"
    echo "Test content for file$j in company$i" > "$FILE_TXT"
    if [ $? -ne 0 ]; then
      echo "Falha ao criar o arquivo $FILE_TXT." >&2
    else
      echo "Arquivo $FILE_TXT criado com sucesso."
    fi

    # Define a data de modificação dos arquivos
    touch -d "$((1 + 3 * (j % 4))) months ago" "$FILE_TXT"
    if [ $? -ne 0 ]; then
      echo "Falha ao modificar a data do arquivo $FILE_TXT." >&2
    else
      echo "Data do arquivo $FILE_TXT ajustada com sucesso."
    fi
  done
done

# Copiando os arquivos do diretório antigo para o novo
echo "Copiando arquivos de $OLD_BASE_DIR para $NEW_BASE_DIR..."
cp -r $OLD_BASE_DIR/* $NEW_BASE_DIR/
if [ $? -ne 0 ]; then
  echo "Falha ao copiar arquivos." >&2
else
  echo "Arquivos copiados com sucesso de $OLD_BASE_DIR para $NEW_BASE_DIR."
fi

echo "Processo de criação de pastas e arquivos completado com sucesso em $NEW_BASE_DIR."

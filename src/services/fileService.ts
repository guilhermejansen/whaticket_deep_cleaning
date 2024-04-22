// src/services/fileService.ts
import fs from 'fs-extra';
import path from 'path';
import archiver from 'archiver';
import config from '../config';
import { sendBackupToWebhook } from './webhookService';
import { uploadToS3 } from './storageService';

async function zipAndBackupFiles(companyDir: string, companyId: string): Promise<void> {
  console.log(`Iniciando o processo de compactação para a empresa: ${companyId}`);

  const zipFilePath = path.join('/tmp', `${companyId}.zip`);
  console.log(`Arquivo ZIP será criado em: ${zipFilePath}`);

  const output = fs.createWriteStream(zipFilePath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  archive.on('error', err => {
    throw new Error(`Erro durante a compactação: ${err}`);
  });

  archive.pipe(output);
  archive.directory(companyDir, false);
  await archive.finalize();
  console.log(`Compactação concluída para: ${zipFilePath}`);

  // Verifica se cada serviço está habilitado antes de enviar
  if (config.webhookEnabled) {
    console.log(`Enviando backup para o Webhook para a empresa: ${companyId}`);
    await sendBackupToWebhook(zipFilePath, companyId);
    console.log('Backup enviado com sucesso para o Webhook!');
  }
  if (config.s3Enabled) {
    console.log(`Enviando backup para o S3 para a empresa: ${companyId}`);
    await uploadToS3(zipFilePath, companyId);
    console.log('Backup enviado com sucesso para o S3!');
  }

  try {
    console.log(`Removendo diretório após backup: ${companyDir}`);
    fs.removeSync(companyDir);
    console.log('Diretório removido com sucesso!');
  } catch (error) {
    console.error(`Erro ao limpar diretório ${companyDir}: ${error}`);
  }
}

export async function processCompanyDirectories(): Promise<void> {
  console.log(`Buscando diretórios em: ${config.publicDir}`);
  const companyDirs = await fs.readdir(config.publicDir);
  console.log(`Encontrados ${companyDirs.length} diretórios para processamento.`);

  for (const dir of companyDirs) {
    const companyDirPath = path.join(config.publicDir, dir);
    console.log(`Verificando se é um diretório: ${companyDirPath}`);
    const stats = await fs.stat(companyDirPath);

    if (stats.isDirectory()) {
      console.log(`Processando o diretório da empresa: ${dir}`);
      await zipAndBackupFiles(companyDirPath, dir);
    }
  }
}

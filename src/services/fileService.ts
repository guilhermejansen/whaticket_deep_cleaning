// src/services/fileService.ts
import { logger } from "../utils/Logger";
import fs from 'fs-extra';
import path from 'path';
import archiver from 'archiver';
import config from '../config';
import { sendBackupToWebhook } from './webhookService';
import { uploadToS3 } from './storageService';

async function zipAndBackupFiles(companyDir: string, companyId: string): Promise<void> {
  logger.info(`Iniciando o processo de compactação para a empresa: ${companyId}`);

  const zipFilePath = path.join('/tmp', `${companyId}.zip`);
  logger.info(`Arquivo ZIP será criado em: ${zipFilePath}`);

  const output = fs.createWriteStream(zipFilePath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  archive.on('error', err => {
    throw new Error(`Erro durante a compactação: ${err}`);
  });

  archive.pipe(output);
  archive.directory(companyDir, false);
  await archive.finalize();
  logger.info(`Compactação concluída para: ${zipFilePath}`);

  // Verifica se cada serviço está habilitado antes de enviar
  if (config.webhookEnabled) {
    logger.info(`Enviando backup para o Webhook para a empresa: ${companyId}`);
    await sendBackupToWebhook(zipFilePath, companyId);
    logger.info('Backup enviado com sucesso para o Webhook!');
  }
  if (config.s3Enabled) {
    logger.info(`Enviando backup para o S3 para a empresa: ${companyId}`);
    await uploadToS3(zipFilePath, companyId);
    logger.info('Backup enviado com sucesso para o S3!');
  }

  try {
    logger.info(`Removendo diretório após backup: ${companyDir}`);
    fs.removeSync(companyDir);
    logger.info('Diretório removido com sucesso!');
  } catch (error) {
    console.error(`Erro ao limpar diretório ${companyDir}: ${error}`);
  }
}

export async function processCompanyDirectories(): Promise<void> {
  logger.info(`Buscando diretórios em: ${config.publicDir}`);
  const companyDirs = await fs.readdir(config.publicDir);
  logger.info(`Encontrados ${companyDirs.length} diretórios para processamento.`);

  for (const dir of companyDirs) {
    const companyDirPath = path.join(config.publicDir, dir);
    logger.info(`Verificando se é um diretório: ${companyDirPath}`);
    const stats = await fs.stat(companyDirPath);

    if (stats.isDirectory()) {
      logger.info(`Processando o diretório da empresa: ${dir}`);
      await zipAndBackupFiles(companyDirPath, dir);
    }
  }
}

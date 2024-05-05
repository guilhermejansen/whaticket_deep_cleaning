// src/utils/cronJobs.ts
import { logger } from "./Logger";
import cron from 'node-cron';
import { processCompanyDirectories } from '../services/fileService';

export function setupCronJobs(): void {
  cron.schedule('* * * * *', () => {  // Isso configurará o job para meia-noite diariamente
    logger.info('Iniciando a limpeza programada de arquivos...');
    processCompanyDirectories();
  });
}

import cron from 'node-cron';
import { processCompanyDirectories } from '../services/fileService';

export function setupCronJobs(): void {
  cron.schedule('0 0 * * *', () => {  // Isso configurará o job para meia-noite diariamente
    console.log('Iniciando a limpeza programada de arquivos...');
    processCompanyDirectories();
  });
}

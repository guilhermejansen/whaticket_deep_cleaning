import cron from 'node-cron';
import { processCompanyDirectories } from '../services/fileService';

export function setupCronJobs(): void {
  // Executar todos os dias à meia-noite
  cron.schedule('* * * * *', () => {
    console.log('Executando a tarefa a cada minuto para teste.');
//  cron.schedule('0 0 * * *', () => {
//    console.log('Iniciando a limpeza programada de arquivos...');*
    processCompanyDirectories();
  });
}

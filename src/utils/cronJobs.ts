import cron from 'node-cron';
import { deleteOldFilesAndBackup } from '../services/fileService';

export const startCronJobs = (dirPath: string): void => {
  cron.schedule('0 0 * * *', async () => {
    console.log('Executando a limpeza diária de arquivos...');
    await deleteOldFilesAndBackup(dirPath);
  });
};

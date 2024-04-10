import axios from 'axios';
import { loadConfig } from '../config';

export const sendBackupToWebhook = async (backupData: any): Promise<void> => {
  const { webhookUrl } = loadConfig();

  try {
    await axios.post(webhookUrl, backupData, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
    console.log('Backup enviado com sucesso.');
  } catch (error) {
    console.error('Erro ao enviar backup:', error);
  }
};

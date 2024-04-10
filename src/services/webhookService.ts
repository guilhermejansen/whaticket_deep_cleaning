import axios from 'axios';
import config from '../config';
import fs from 'fs';

export async function sendBackupToWebhook(zipFilePath: string, companyId: string): Promise<void> {
  if (!config.webhookUrl) return;

  const zipFileBuffer = fs.readFileSync(zipFilePath);

  // Implemente sua lógica de reenvio aqui. Abaixo está uma versão simplificada.
  let attempts = 0;
  while (attempts < 3) {
    try {
      await axios.post(config.webhookUrl, zipFileBuffer, {
        headers: {
          'Content-Type': 'application/zip',
          'Company-ID': companyId,
        },
      });
      console.log(`Backup enviado com sucesso para a compania ${companyId}.`);
      break;
    } catch (error) {
      console.error(`Falha ao enviar backup para a compania ${companyId}. Tentativa ${attempts + 1}`);
      attempts++;
    }
  }

  if (attempts === 3) {
    console.error(`Falha após 3 tentativas para a compania ${companyId}.`);
  }
}

import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';
import config from '../config';

export async function sendBackupToWebhook(zipFilePath: string, companyId: string): Promise<void> {
  if (!config.webhookUrl) {
    console.log(`URL do webhook não configurada, envio omitido para companyId: ${companyId}`);
    return;
  }

  console.log(`Preparando para enviar backup para o webhook para companyId: ${companyId}`);
  
  try {
    const fileBuffer = await fs.promises.readFile(zipFilePath);
    const stats = await fs.promises.stat(zipFilePath);

    if (fileBuffer.length !== stats.size) {
      throw new Error(`Erro na leitura do arquivo: o tamanho do buffer (${fileBuffer.length} bytes) não corresponde ao tamanho do arquivo (${stats.size} bytes).`);
    }

    const formData = new FormData();
    formData.append('file', fileBuffer, `${companyId}.zip`);
    formData.append('companyId', companyId);
    formData.append('timestamp', new Date().toISOString());

    let attempts = 0;
    while (attempts < 3) {
      console.log(`Tentando enviar backup para o webhook, tentativa ${attempts + 1}, para companyId: ${companyId}`);
      const response = await axios.post(config.webhookUrl, formData, { headers: { ...formData.getHeaders() } });
      console.log(`Resposta do webhook: ${response.status}`);

      if (response.status === 200) {
        console.log(`Backup enviado com sucesso para o webhook para companyId: ${companyId}`);
        break;
      } else {
        throw new Error(`HTTP status: ${response.status}`);
      }
      attempts++;
    }

    if (attempts === 3) {
      console.error(`Falha ao enviar backup após 3 tentativas para companyId: ${companyId}`);
    }
  } catch (error) {
    console.error(`Falha ao enviar backup para o webhook para companyId: ${companyId}: ${error}`);
  }
}

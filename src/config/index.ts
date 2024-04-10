import fs from 'fs';
import path from 'path';

interface AppConfig {
  retentionTime: number;
  webhookUrl: string;
}

const configFilePath = path.join(__dirname, '../../config.json');

export const loadConfig = (): AppConfig => {
  if (!fs.existsSync(configFilePath)) {
    throw new Error('Configuração não encontrada. Execute o script de instalação.');
  }

  const configData = fs.readFileSync(configFilePath);
  return JSON.parse(configData.toString());
};

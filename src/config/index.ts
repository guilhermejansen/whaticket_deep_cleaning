// src/config/index.ts
import dotenv from 'dotenv';

dotenv.config();

interface Config {
  retentionMonths: number;
  webhookUrl: string | null;
  publicDir: string;
  webhookEnabled: boolean;
  s3Enabled: boolean;
}

// Função auxiliar para converter string para booleano
const parseBool = (value: string | undefined, defaultValue: boolean): boolean => {
  if (value === undefined) {
    return defaultValue;
  }
  return value.toLowerCase() === 'true';
}

const config: Config = {
  retentionMonths: parseInt(process.env.RETENTION_MONTHS || '3', 10),
  webhookUrl: process.env.WEBHOOK_URL || null,
  publicDir: process.env.PUBLIC_DIR || '/home/deploy/whaticket/backend/public',
  webhookEnabled: parseBool(process.env.WEBHOOK_ENABLED, false),
  s3Enabled: parseBool(process.env.S3_ENABLED, false),
};

// Validando as configurações críticas
if (!config.publicDir) {
  throw new Error("A variável PUBLIC_DIR é obrigatória e não está definida.");
}
if (config.s3Enabled && (!process.env.MINIO_ACCESS_KEY || !process.env.MINIO_SECRET_KEY || !process.env.MINIO_ENDPOINT)) {
  throw new Error("As configurações de MinIO são obrigatórias para S3 estar habilitado.");
}

export default config;

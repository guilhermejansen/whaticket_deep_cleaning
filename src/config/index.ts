import dotenv from 'dotenv';

dotenv.config();

interface Config {
  retentionMonths: number;
  webhookUrl: string | null;
  publicDir: string;
}

const config: Config = {
  retentionMonths: parseInt(process.env.RETENTION_MONTHS || '6', 10),
  webhookUrl: process.env.WEBHOOK_URL || null,
  publicDir: '/home/setup/multi100/backend/public',

};

export default config;
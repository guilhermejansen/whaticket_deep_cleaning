import { startCronJobs } from './utils/cronJobs';
import dotenv from 'dotenv';
dotenv.config();

const dirPath = '/home/deploy/multi100/backend/public';

startCronJobs(dirPath);



// Agora você pode acessar as variáveis de ambiente com process.env
console.log(process.env.RETENTION_TIME);
console.log(process.env.WEBHOOK_URL);

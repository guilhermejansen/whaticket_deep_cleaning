// src/index.ts
import { logger } from "./utils/Logger";
import { setupCronJobs } from './utils/cronJobs';

setupCronJobs();
logger.info('Aplicação de limpeza iniciada.');

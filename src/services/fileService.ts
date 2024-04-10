import fs from 'fs-extra';
import path from 'path';
import archiver from 'archiver'; // Garanta que 'archiver' esteja instalado via npm
import config from '../config';
import { sendBackupToWebhook } from './webhookService';

async function zipAndBackupFiles(companyDir: string, companyId: string): Promise<void> {
  const zipFilePath = path.join('/tmp', `${companyId}.zip`);
  const output = fs.createWriteStream(zipFilePath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  archive.pipe(output);
  archive.directory(companyDir, false);
  await archive.finalize();

  await sendBackupToWebhook(zipFilePath, companyId);

  // Após o sucesso do webhook, excluir arquivos
  fs.removeSync(companyDir); // Tenha cuidado ao usar remoções sincronizadas
}

export async function processCompanyDirectories(): Promise<void> {
  const companyDirs = await fs.readdir(config.publicDir);

  for (const dir of companyDirs) {
    const companyDirPath = path.join(config.publicDir, dir);
    const stats = await fs.stat(companyDirPath);

    if (stats.isDirectory()) {
      await zipAndBackupFiles(companyDirPath, dir);
    }
  }
}

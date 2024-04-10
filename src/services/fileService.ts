import fs from 'fs-extra';
import path from 'path';
import { loadConfig } from '../config';

export const deleteOldFilesAndBackup = async (dir: string): Promise<void> => {
  const { retentionTime } = loadConfig();
  const files = await fs.readdir(dir);

  for (const file of files) {
    const filePath = path.join(dir, file);
    const stats = await fs.stat(filePath);

    const expirationDate = new Date();
    expirationDate.setMonth(expirationDate.getMonth() - retentionTime);

    if (stats.mtime < expirationDate) {
      // Aqui você deve implementar a lógica para backup do arquivo antes de deletar
      // E depois deletar o arquivo
      console.log(`${filePath} foi apagado.`);
    }
  }
};

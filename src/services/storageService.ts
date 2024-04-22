// src/services/storageService.ts
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import fs from 'fs';
import path from 'path';
import config from '../config';

const credentials = {
  accessKeyId: process.env.MINIO_ACCESS_KEY ?? '', // Fallback para string vazia se undefined
  secretAccessKey: process.env.MINIO_SECRET_KEY ?? '' // Fallback para string vazia se undefined
};
const endpoint = process.env.MINIO_ENDPOINT ?? 'http://localhost:9000'; // Fallback para localhost se undefined

const s3Client = new S3Client({
  credentials,
  endpoint,
  forcePathStyle: true,
  region: "us-east-1" // Região fictícia, pois MinIO não utiliza região
});

export async function uploadToS3(zipFilePath: string, companyId: string): Promise<void> {
    console.log(`Iniciando o upload para o S3 para a empresa: ${companyId}`);
    const fileContent = fs.readFileSync(zipFilePath);
    const now = new Date();
    const timestamp = `${now.getFullYear()}-${now.getMonth()+1}-${now.getDate()}_${now.getHours()}-${now.getMinutes()}-${now.getSeconds()}`;
    const bucketName = process.env.S3_BUCKET_NAME;
    const key = `backups/${companyId}/${timestamp}_${path.basename(zipFilePath)}`;

    console.log(`Preparando para enviar arquivo para o bucket ${bucketName} com chave ${key}`);

    const params = {
      Bucket: bucketName,
      Key: key,
      Body: fileContent,
      ContentType: 'application/zip'
    };

    try {
      const command = new PutObjectCommand(params);
      const data = await s3Client.send(command);
      console.log(`Arquivo enviado com sucesso para o MinIO no caminho: backups/${companyId}/${timestamp}_${path.basename(zipFilePath)}`);
    } catch (err: unknown) {
      if (err instanceof Error) {
        console.error(`Erro ao enviar arquivo para o MinIO: ${err.message}`);
      } else {
        console.error('Erro ao enviar arquivo para o MinIO: Erro desconhecido');
      }
    }
}

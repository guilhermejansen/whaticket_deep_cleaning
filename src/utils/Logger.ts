// src/utils/Logger.ts
import { createLogger, format, transports } from 'winston';

const logLevel = process.env.NODE_ENV === 'development' ? 'debug' : 'info';

const customLogFormat = format.printf(({ level, message, timestamp }) => {
  return `${level.toUpperCase()} [${timestamp}]: ${message}`;
});

const logger = createLogger({
  level: logLevel,
  format: format.combine(
    format.timestamp({
      format: 'DD/MM/YYYY HH:mm:ss'
    }),
    format.errors({ stack: true }),
    format.splat(),
    customLogFormat
  ),
  transports: [
    new transports.File({ filename: 'error.log', level: 'error' }),
    new transports.File({ filename: 'combined.log', level: logLevel })
  ]
});

logger.add(new transports.Console({
  level: logLevel,
  format: format.combine(
    format.colorize({
      all: true
    }),
    customLogFormat
  )
}));

export { logger };

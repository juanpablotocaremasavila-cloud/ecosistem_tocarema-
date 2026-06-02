import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const paths = [
    path.resolve(process.cwd(), '.env'),
    path.resolve(__dirname, '.env'),
    path.resolve(__dirname, '../.env'),
    path.resolve(__dirname, '../../.env')
];

let loaded = false;
for (const p of paths) {
    if (fs.existsSync(p)) {
        dotenv.config({ path: p });
        loaded = true;
        break;
    }
}
if (!loaded) {
    dotenv.config();
}

const db = new Sequelize(
    process.env.DB_NAME || process.env.MYSQL_ADDON_DB || 'b0py2ume77nsk8dp10gz',
    process.env.DB_USER || process.env.MYSQL_ADDON_USER || 'utjsesrlthfz0w06',
    process.env.DB_PASSWORD || process.env.MYSQL_ADDON_PASSWORD || '5MPAVxyGFrU29AKQAkWw', 
    {
        host: process.env.DB_HOST || process.env.MYSQL_ADDON_HOST || 'b0py2ume77nsk8dp10gz-mysql.services.clever-cloud.com',
        port: process.env.DB_PORT || process.env.MYSQL_ADDON_PORT || 3306,
        dialect: 'mysql',
        dialectOptions: process.env.DB_HOST && process.env.DB_HOST !== 'localhost' ? {
            ssl: {
                require: true,
                rejectUnauthorized: false
            }
        } : {},    }
);

export default db;
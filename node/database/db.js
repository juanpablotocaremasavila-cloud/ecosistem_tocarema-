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

const dbUri = process.env.CUSTOM_DB_URI || process.env.MYSQL_ADDON_URI || process.env.DATABASE_URL;

let db;

if (dbUri) {
    db = new Sequelize(dbUri, {
        dialect: 'mysql',
        logging: false
    });
} else {
    db = new Sequelize(
        process.env.DB_NAME || process.env.MYSQL_ADDON_DB || 'b9jko1oukptwzzegvaku',
        process.env.DB_USER || process.env.MYSQL_ADDON_USER || 'uuslujulkqioljpp',
        process.env.DB_PASSWORD || process.env.MYSQL_ADDON_PASSWORD || 'SULMgIzB7FXWLOiIBmPp', 
        {
            host: process.env.DB_HOST || process.env.MYSQL_ADDON_HOST || 'b9jko1oukptwzzegvaku-mysql.services.clever-cloud.com',
            port: process.env.DB_PORT || process.env.MYSQL_ADDON_PORT || 3306,
            dialect: 'mysql',
            logging: false
        }
    );
}

export default db;
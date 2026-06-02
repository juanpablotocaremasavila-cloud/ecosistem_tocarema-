import db from './database/db.js';
import './models/associations.js';

async function syncDB() {
    try {
        await db.authenticate();
        console.log('✅ Conexión establecida a MySQL');
        
        console.log('🔄 Sincronizando modelos con la base de datos...');
        await db.sync({ alter: true });
        
        console.log('✅ Base de datos sincronizada exitosamente.');
    } catch (error) {
        console.error('❌ Error sincronizando base de datos:', error.message);
        // No usar process.exit(1) para no detener el build de Clever Cloud
        console.warn('⚠️ Continuando sin sincronizar la base de datos...');
    } finally {
        await db.close().catch(() => {});
    }
}

syncDB();

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'spinflow.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await _createFabricanteTable(db);
    // Adicione outras tabelas aqui conforme necessário
  }

  Future<void> _createFabricanteTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS fabricantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        descricao TEXT,
        nome_contato_principal TEXT,
        email_contato TEXT,
        telefone_contato TEXT,
        ativo INTEGER NOT NULL DEFAULT 1,
        data_criacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        data_atualizacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT chk_nome_length CHECK (LENGTH(nome) >= 2),
        CONSTRAINT chk_email_format CHECK (
          email_contato IS NULL OR 
          email_contato LIKE '%@%.%'
        ),
        CONSTRAINT chk_telefone_format CHECK (
          telefone_contato IS NULL OR 
          LENGTH(telefone_contato) >= 10
        ),
        CONSTRAINT chk_ativo_bool CHECK (ativo IN (0, 1))
      )
    ''');

    // Criar índices para melhor performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_fabricantes_nome 
      ON fabricantes(nome)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_fabricantes_ativo 
      ON fabricantes(ativo)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_fabricantes_email 
      ON fabricantes(email_contato)
    ''');

    // Trigger para atualizar data_atualizacao automaticamente
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS update_fabricantes_timestamp 
      AFTER UPDATE ON fabricantes
      BEGIN
        UPDATE fabricantes 
        SET data_atualizacao = CURRENT_TIMESTAMP 
        WHERE id = NEW.id;
      END
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações aqui quando necessário
    if (oldVersion < newVersion) {
      // Exemplo de migração:
      // if (oldVersion < 2) {
      //   await db.execute('ALTER TABLE fabricantes ADD COLUMN nova_coluna TEXT');
      // }
    }
  }

  // Método para resetar o banco (útil para desenvolvimento)
  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'spinflow.db');
    await deleteDatabase(path);
    _database = null;
  }

  // Método para fechar o banco
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

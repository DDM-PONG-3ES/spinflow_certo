import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';

class FabricanteDAO {
  static const String _tableName = 'fabricantes';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Inserir novo fabricante
  Future<int> inserir(DTOFabricante fabricante) async {
    final db = await _databaseHelper.database;
    
    final Map<String, dynamic> fabricanteMap = {
      'nome': fabricante.nome.trim(),
      'descricao': fabricante.descricao?.trim(),
      'nome_contato_principal': fabricante.nome_contato_principal?.trim(),
      'email_contato': fabricante.email_contato?.trim().toLowerCase(),
      'telefone_contato': _formatTelefone(fabricante.telefone_contato),
      'ativo': fabricante.ativo ? 1 : 0,
    };

    try {
      return await db.insert(
        _tableName,
        fabricanteMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Já existe um fabricante com este nome');
      }
      rethrow;
    }
  }

  // Atualizar fabricante existente
  Future<int> atualizar(DTOFabricante fabricante) async {
    final db = await _databaseHelper.database;
    
    if (fabricante.id == null) {
      throw Exception('ID do fabricante não pode ser nulo para atualização');
    }

    final Map<String, dynamic> fabricanteMap = {
      'nome': fabricante.nome.trim(),
      'descricao': fabricante.descricao?.trim(),
      'nome_contato_principal': fabricante.nome_contato_principal?.trim(),
      'email_contato': fabricante.email_contato?.trim().toLowerCase(),
      'telefone_contato': _formatTelefone(fabricante.telefone_contato),
      'ativo': fabricante.ativo ? 1 : 0,
    };

    try {
      return await db.update(
        _tableName,
        fabricanteMap,
        where: 'id = ?',
        whereArgs: [fabricante.id],
      );
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Já existe um fabricante com este nome');
      }
      rethrow;
    }
  }

  // Buscar fabricante por ID
  Future<DTOFabricante?> buscarPorId(int id) async {
    final db = await _databaseHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToDTO(maps.first);
    }
    return null;
  }

  // Listar todos os fabricantes
  Future<List<DTOFabricante>> listarTodos({bool? apenasAtivos}) async {
    final db = await _databaseHelper.database;
    
    String? where;
    List<dynamic>? whereArgs;
    
    if (apenasAtivos != null) {
      where = 'ativo = ?';
      whereArgs = [apenasAtivos ? 1 : 0];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'nome ASC',
    );

    return maps.map((map) => _mapToDTO(map)).toList();
  }

  // Buscar fabricantes por nome (busca parcial)
  Future<List<DTOFabricante>> buscarPorNome(String nome) async {
    final db = await _databaseHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'nome LIKE ?',
      whereArgs: ['%${nome.trim()}%'],
      orderBy: 'nome ASC',
    );

    return maps.map((map) => _mapToDTO(map)).toList();
  }

  // Excluir fabricante (soft delete - apenas marca como inativo)
  Future<int> excluirSoft(int id) async {
    final db = await _databaseHelper.database;
    
    return await db.update(
      _tableName,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Excluir fabricante permanentemente
  Future<int> excluirPermanente(int id) async {
    final db = await _databaseHelper.database;
    
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Contar fabricantes
  Future<int> contar({bool? apenasAtivos}) async {
    final db = await _databaseHelper.database;
    
    String? where;
    List<dynamic>? whereArgs;
    
    if (apenasAtivos != null) {
      where = 'ativo = ?';
      whereArgs = [apenasAtivos ? 1 : 0];
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName ${where != null ? 'WHERE $where' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Verificar se nome já existe
  Future<bool> nomeJaExiste(String nome, {int? excluirId}) async {
    final db = await _databaseHelper.database;
    
    String where = 'nome = ?';
    List<dynamic> whereArgs = [nome.trim()];
    
    if (excluirId != null) {
      where += ' AND id != ?';
      whereArgs.add(excluirId);
    }

    final result = await db.query(
      _tableName,
      where: where,
      whereArgs: whereArgs,
    );

    return result.isNotEmpty;
  }
  // Converter Map do banco para DTO
  DTOFabricante _mapToDTO(Map<String, dynamic> map) {
    return DTOFabricante(
      id: map['id'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      nome_contato_principal: map['nome_contato_principal'],
      email_contato: map['email_contato'],
      telefone_contato: map['telefone_contato'],
      ativo: (map['ativo'] ?? 1) == 1,
    );
  }

  // Formatar telefone com máscara
  String? _formatTelefone(String? telefone) {
    if (telefone == null || telefone.trim().isEmpty) return null;
    
    // Remove tudo que não é número
    String numeroLimpo = telefone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Aplica máscara baseada no tamanho
    if (numeroLimpo.length == 10) {
      // Telefone fixo: (xx) xxxx-xxxx
      return '(${numeroLimpo.substring(0, 2)}) ${numeroLimpo.substring(2, 6)}-${numeroLimpo.substring(6)}';
    } else if (numeroLimpo.length == 11) {
      // Celular: (xx) xxxxx-xxxx
      return '(${numeroLimpo.substring(0, 2)}) ${numeroLimpo.substring(2, 7)}-${numeroLimpo.substring(7)}';
    }
    
    // Retorna o número original se não seguir o padrão esperado
    return telefone;
  }
}

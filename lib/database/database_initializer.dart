import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/dao/fabricante_dao.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';

class DatabaseInitializer {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();
  static final FabricanteDAO _fabricanteDAO = FabricanteDAO();

  /// Inicializa o banco de dados e popula com dados iniciais se necessário
  static Future<void> initialize() async {
    try {
      // Garante que o banco está criado
      await _databaseHelper.database;
      
      // Verifica se já existem fabricantes cadastrados
      final count = await _fabricanteDAO.contar();
      
      // Se não há fabricantes, popula com dados iniciais
      if (count == 0) {
        await _popularDadosIniciais();
      }
      
      print('✅ Banco de dados inicializado com sucesso!');
    } catch (e) {
      print('❌ Erro ao inicializar banco de dados: $e');
      rethrow;
    }
  }

  /// Popula o banco com dados iniciais de fabricantes
  static Future<void> _popularDadosIniciais() async {
    final fabricantesIniciais = [
      DTOFabricante(
        nome: "SchwinnFitness",
        descricao: "Líder mundial em equipamentos de spinning e ciclismo indoor. Oferece bikes de alta qualidade com tecnologia avançada.",
        nome_contato_principal: "Carlos Silva",
        email_contato: "vendas@schwinnfitness.com.br",
        telefone_contato: "(11) 3456-7890",
        ativo: true,
      ),
      DTOFabricante(
        nome: "Life Fitness",
        descricao: "Fabricante premium de equipamentos para academias, especializada em bikes de spinning com recursos inovadores.",
        nome_contato_principal: "Ana Santos",
        email_contato: "contato@lifefitness.com.br",
        telefone_contato: "(11) 2345-6789",
        ativo: true,
      ),
      DTOFabricante(
        nome: "Keiser Corporation",
        descricao: "Pioneira em bikes de spinning com resistência magnética, oferecendo equipamentos silenciosos e duráveis.",
        nome_contato_principal: "Roberto Oliveira",
        email_contato: "info@keiser.com.br",
        telefone_contato: "(11) 4567-8901",
        ativo: false,
      ),
      DTOFabricante(
        nome: "Matrix Fitness",
        descricao: "Fabricante de equipamentos de spinning conectados com tecnologia virtual e monitoramento avançado.",
        nome_contato_principal: "Mariana Costa",
        email_contato: "vendas@matrixfitness.com.br",
        telefone_contato: "(11) 5678-9012",
        ativo: true,
      ),
      DTOFabricante(
        nome: "Peloton Brasil",
        descricao: "Especialista em bikes de spinning inteligentes com aulas virtuais e comunidade online integrada.",
        nome_contato_principal: "Fernando Lima",
        email_contato: "suporte@peloton.com.br",
        telefone_contato: "(11) 6789-0123",
        ativo: true,
      ),
      DTOFabricante(
        nome: "Spinner Pro",
        descricao: "Fabricante nacional de bikes de spinning resistentes e acessíveis para academias de todos os portes.",
        nome_contato_principal: "Juliana Ferreira",
        email_contato: "comercial@spinnerpro.com.br",
        telefone_contato: "(11) 7890-1234",
        ativo: true,
      ),
    ];

    try {
      for (final fabricante in fabricantesIniciais) {
        await _fabricanteDAO.inserir(fabricante);
      }
      print('✅ Dados iniciais de fabricantes inseridos com sucesso!');
    } catch (e) {
      print('❌ Erro ao inserir dados iniciais: $e');
      rethrow;
    }
  }

  /// Limpa todos os dados do banco (útil para desenvolvimento)
  static Future<void> limparDados() async {
    try {
      await _databaseHelper.resetDatabase();
      print('✅ Dados do banco limpos com sucesso!');
    } catch (e) {
      print('❌ Erro ao limpar dados: $e');
      rethrow;
    }
  }

  /// Fecha a conexão com o banco
  static Future<void> fecharConexao() async {
    try {
      await _databaseHelper.close();
      print('✅ Conexão com banco fechada com sucesso!');
    } catch (e) {
      print('❌ Erro ao fechar conexão: $e');
    }
  }
}

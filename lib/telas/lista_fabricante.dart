import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';

// Mock de dados de fabricantes de spinning
final List<DTOFabricante> mockFabricantes = [
  DTOFabricante(
    id: 1,
    nome: "SchwinnFitness",
    descricao: "Líder mundial em equipamentos de spinning e ciclismo indoor. Oferece bikes de alta qualidade com tecnologia avançada.",
    nome_contato_principal: "Carlos Silva",
    email_contato: "vendas@schwinnfitness.com.br",
    telefone_contato: "(11) 3456-7890",
    ativo: true,
  ),
  DTOFabricante(
    id: 2,
    nome: "Life Fitness",
    descricao: "Fabricante premium de equipamentos para academias, especializada em bikes de spinning com recursos inovadores.",
    nome_contato_principal: "Ana Santos",
    email_contato: "contato@lifefitness.com.br",
    telefone_contato: "(11) 2345-6789",
    ativo: true,
  ),
  DTOFabricante(
    id: 3,
    nome: "Keiser Corporation",
    descricao: "Pioneira em bikes de spinning com resistência magnética, oferecendo equipamentos silenciosos e duráveis.",
    nome_contato_principal: "Roberto Oliveira",
    email_contato: "info@keiser.com.br",
    telefone_contato: "(11) 4567-8901",
    ativo: false,
  ),
  DTOFabricante(
    id: 4,
    nome: "Matrix Fitness",
    descricao: "Fabricante de equipamentos de spinning conectados com tecnologia virtual e monitoramento avançado.",
    nome_contato_principal: "Mariana Costa",
    email_contato: "vendas@matrixfitness.com.br",
    telefone_contato: "(11) 5678-9012",
    ativo: true,
  ),
  DTOFabricante(
    id: 5,
    nome: "Peloton Brasil",
    descricao: "Especialista em bikes de spinning inteligentes com aulas virtuais e comunidade online integrada.",
    nome_contato_principal: "Fernando Lima",
    email_contato: "suporte@peloton.com.br",
    telefone_contato: "(11) 6789-0123",
    ativo: true,
  ),
  DTOFabricante(
    id: 6,
    nome: "Spinner Pro",
    descricao: "Fabricante nacional de bikes de spinning resistentes e acessíveis para academias de todos os portes.",
    nome_contato_principal: "Juliana Ferreira",
    email_contato: "comercial@spinnerpro.com.br",
    telefone_contato: "(11) 7890-1234",
    ativo: true,
  ),
];

class ListaFabricante extends StatefulWidget {
  const ListaFabricante({super.key});

  @override
  State<ListaFabricante> createState() => _ListaFabricanteState();
}

class _ListaFabricanteState extends State<ListaFabricante> {
  List<DTOFabricante> fabricantes = List.from(mockFabricantes);

  void _excluirFabricante(DTOFabricante fabricante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                const TextSpan(text: 'Deseja realmente excluir o fabricante '),
                TextSpan(
                  text: '"${fabricante.nome}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '?\n\n'),
                const TextSpan(
                  text: 'Esta ação não pode ser desfeita.',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fabricantes.removeWhere((f) => f.id == fabricante.id);
                });
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Fabricante "${fabricante.nome}" excluído com sucesso!'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _alterarFabricante(DTOFabricante fabricante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Fabricante'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('ID:', fabricante.id?.toString() ?? 'N/A'),
                _buildInfoRow('Nome:', fabricante.nome),
                _buildInfoRow('Descrição:', fabricante.descricao ?? 'Não informado'),                _buildInfoRow('Contato:', fabricante.nome_contato_principal ?? 'Não informado'),
                _buildInfoRow('Email:', fabricante.email_contato ?? 'Não informado'),
                _buildInfoRow('Telefone:', fabricante.telefone_contato ?? 'Não informado'),
                _buildInfoRow('Status:', fabricante.ativo ? 'Ativo' : 'Inativo'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            ElevatedButton(              onPressed: () {
                Navigator.of(context).pop();
                // Navegando para a tela de edição do fabricante
                Navigator.pushNamed(
                  context, 
                  '/fabricante',
                  arguments: fabricante.id, // Passando o ID do fabricante
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Fabricantes'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header com informações
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(
                  Icons.business,
                  size: 24,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fabricantes de Spinning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    Text(
                      '${fabricantes.length} fabricante(s) encontrado(s)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Lista de fabricantes
          Expanded(
            child: fabricantes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum fabricante encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: fabricantes.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final fabricante = fabricantes[index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: fabricante.ativo 
                                ? Colors.green[100] 
                                : Colors.red[100],
                            child: Icon(
                              Icons.business,
                              color: fabricante.ativo 
                                  ? Colors.green[700] 
                                  : Colors.red[700],
                            ),
                          ),
                          title: Text(
                            fabricante.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (fabricante.descricao != null)
                                Text(
                                  fabricante.descricao!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              const SizedBox(height: 8), Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    fabricante.nome_contato_principal ?? 'Não informado',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      fabricante.email_contato ?? 'Não informado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: fabricante.ativo 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  fabricante.ativo ? 'Ativo' : 'Inativo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: fabricante.ativo 
                                        ? Colors.green[700] 
                                        : Colors.red[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _alterarFabricante(fabricante),
                                icon: const Icon(Icons.edit),
                                color: Colors.orange,
                                tooltip: 'Alterar fabricante',
                              ),
                              IconButton(
                                onPressed: () => _excluirFabricante(fabricante),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                tooltip: 'Excluir fabricante',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para tela de cadastro de fabricante
          Navigator.pushNamed(context, '/fabricante');
        },
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

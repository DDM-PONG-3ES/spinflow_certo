import 'package:flutter/material.dart';

class FormFabricante extends StatefulWidget {
  const FormFabricante({super.key});

  @override
  State<FormFabricante> createState() => _FormFabricanteState();
}

class _FormFabricanteState extends State<FormFabricante> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _nomeContatoController = TextEditingController();
  final _emailContatoController = TextEditingController();
  final _telefoneContatoController = TextEditingController();

  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _nomeContatoController.dispose();
    _emailContatoController.dispose();
    _telefoneContatoController.dispose();
    super.dispose();
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? _validarDescricao(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }
    if (value.trim().length < 10) {
      return 'Descrição deve ter pelo menos 10 caracteres';
    }
    return null;
  }

  String? _validarNomeContato(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome do contato é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }

    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!emailPattern.hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

  void _salvarFabricante() {
    if (_formKey.currentState!.validate()) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final fabricante = {
        'id': id,
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'nome_contato_principal': _nomeContatoController.text.trim(),
        'email_contato': _emailContatoController.text.trim(),
        'telefone_contato': _telefoneContatoController.text.trim(),
        'ativo': _ativo,
        'dataCadastro': DateTime.now().toIso8601String(),
      };

      print('Fabricante salvo: $fabricante');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fabricante "${_nomeController.text}" salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _nomeController.clear();
    _descricaoController.clear();
    _nomeContatoController.clear();
    _emailContatoController.clear();
    _telefoneContatoController.clear();
    setState(() {
      _ativo = true;
    });
  }

  void _voltarTela() {
    if (_nomeController.text.isNotEmpty ||
        _descricaoController.text.isNotEmpty ||
        _nomeContatoController.text.isNotEmpty ||
        _emailContatoController.text.isNotEmpty ||
        _telefoneContatoController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('Há dados não salvos. Deseja realmente sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Sair'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Fabricante'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _voltarTela,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header com ícone
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 32,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Novo Fabricante',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const Text(
                            'Preencha os dados abaixo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Campo Nome (obrigatório)
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Fabricante *',
                  hintText: 'Ex: Empresa XYZ Ltda',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarNome,
                textCapitalization: TextCapitalization.words,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo Descrição (obrigatório)
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição *',
                  hintText: 'Descreva a empresa e seus produtos',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Mínimo de 10 caracteres',
                ),
                validator: _validarDescricao,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 500,
              ),

              const SizedBox(height: 16),

              // Campo Nome do Contato Principal (obrigatório)
              TextFormField(
                controller: _nomeContatoController,
                decoration: InputDecoration(
                  labelText: 'Nome do Contato Principal *',
                  hintText: 'Ex: João Silva',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarNomeContato,
                textCapitalization: TextCapitalization.words,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo Email de Contato (obrigatório)
              TextFormField(
                controller: _emailContatoController,
                decoration: InputDecoration(
                  labelText: 'Email de Contato *',
                  hintText: 'contato@empresa.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarEmail,
                keyboardType: TextInputType.emailAddress,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo Telefone de Contato (obrigatório)
              TextFormField(
                controller: _telefoneContatoController,
                decoration: InputDecoration(
                  labelText: 'Telefone de Contato *',
                  hintText: '(11) 99999-9999',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Com DDD',
                ),
                validator: _validarTelefone,
                keyboardType: TextInputType.phone,
                maxLength: 15,
              ),

              const SizedBox(height: 16),

              // Campo Ativo (Switch)
              Card(
                child: SwitchListTile(
                  title: const Text('Fabricante Ativo'),
                  subtitle: Text(
                    _ativo
                        ? 'Este fabricante estará ativo no sistema'
                        : 'Este fabricante estará inativo',
                  ),
                  value: _ativo,
                  onChanged: (value) {
                    setState(() {
                      _ativo = value;
                    });
                  },
                  activeColor: Colors.green,
                  secondary: Icon(
                    _ativo ? Icons.check_circle : Icons.cancel,
                    color: _ativo ? Colors.green : Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Campos obrigatórios info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    const Text(
                      '* Campos obrigatórios',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _limparFormulario,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear),
                          SizedBox(width: 8),
                          Text('Limpar'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _salvarFabricante,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text('Salvar Fabricante'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FormAluno extends StatefulWidget {
  const FormAluno({super.key});

  @override
  State<FormAluno> createState() => _FormAlunoState();
}

class _FormAlunoState extends State<FormAluno> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _telefoneContatoController = TextEditingController();
  final _perfilInstagramController = TextEditingController();
  final _perfilFacebookController = TextEditingController();
  final _perfilTiktokController = TextEditingController();

  String? _genero;
  bool _ativo = true;

  final List<String> _opcoesGenero = [
    'Masculino',
    'Feminino',
    'Outro',
    'Prefiro não informar'
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _telefoneContatoController.dispose();
    _perfilInstagramController.dispose();
    _perfilFacebookController.dispose();
    _perfilTiktokController.dispose();
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

  String? _validarDataNascimento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Data de nascimento é obrigatória';
    }

    // Validar formato DD/MM/AAAA
    final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!datePattern.hasMatch(value.trim())) {
      return 'Use o formato DD/MM/AAAA';
    }

    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      final now = DateTime.now();

      if (date.isAfter(now)) {
        return 'Data não pode ser futura';
      }

      final age = now.year - date.year;
      if (age > 120) {
        return 'Data inválida';
      }
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo não obrigatório
    }

    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

  String? _validarPerfilSocial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campos não obrigatórios
    }

    // Validação básica de URL ou username
    final url = value.trim();
    if (url.startsWith('http') || url.startsWith('www.')) {
      final urlPattern = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
        caseSensitive: false,
      );
      if (!urlPattern.hasMatch(url)) {
        return 'URL inválida';
      }
    } else if (url.startsWith('@')) {
      if (url.length < 2) {
        return 'Username inválido';
      }
    }
    return null;
  }

  void _salvarAluno() {
    if (_formKey.currentState!.validate()) {
      if (_genero == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione o gênero'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final aluno = {
        'id': id,
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'data_nascimento': _dataNascimentoController.text.trim(),
        'genero': _genero,
        'telefone_contato': _telefoneContatoController.text.trim().isEmpty
            ? null
            : _telefoneContatoController.text.trim(),
        'perfil_instagram': _perfilInstagramController.text.trim().isEmpty
            ? null
            : _perfilInstagramController.text.trim(),
        'perfil_facebook': _perfilFacebookController.text.trim().isEmpty
            ? null
            : _perfilFacebookController.text.trim(),
        'perfil_tiktok': _perfilTiktokController.text.trim().isEmpty
            ? null
            : _perfilTiktokController.text.trim(),
        'ativo': _ativo,
        'dataCadastro': DateTime.now().toIso8601String(),
      };

      print('Aluno salvo: $aluno');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aluno "${_nomeController.text}" salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _nomeController.clear();
    _emailController.clear();
    _dataNascimentoController.clear();
    _telefoneContatoController.clear();
    _perfilInstagramController.clear();
    _perfilFacebookController.clear();
    _perfilTiktokController.clear();
    setState(() {
      _genero = null;
      _ativo = true;
    });
  }

  void _voltarTela() {
    if (_nomeController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _dataNascimentoController.text.isNotEmpty ||
        _telefoneContatoController.text.isNotEmpty ||
        _perfilInstagramController.text.isNotEmpty ||
        _perfilFacebookController.text.isNotEmpty ||
        _perfilTiktokController.text.isNotEmpty) {
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

  void _selecionarDataNascimento() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataNascimentoController.text =
            '${dataSelecionada.day.toString().padLeft(2, '0')}/'
            '${dataSelecionada.month.toString().padLeft(2, '0')}/'
            '${dataSelecionada.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Aluno'),
        backgroundColor: Colors.blue[700],
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
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 32,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Novo Aluno',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
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
                  labelText: 'Nome Completo *',
                  hintText: 'Ex: João Silva Santos',
                  prefixIcon: const Icon(Icons.person),
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

              // Campo Email (obrigatório)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  hintText: 'exemplo@email.com',
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

              // Campo Data de Nascimento (com DatePicker)
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento *',
                  hintText: 'DD/MM/AAAA',
                  prefixIcon: const Icon(Icons.cake),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarDataNascimento,
                keyboardType:
                    TextInputType.datetime,
                maxLength:
                    10,
              ),

              const SizedBox(height: 16),

              // Campo Gênero (obrigatório)
              DropdownButtonFormField<String>(
                value: _genero,
                decoration: InputDecoration(
                  labelText: 'Gênero *',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _opcoesGenero.map((String genero) {
                  return DropdownMenuItem<String>(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _genero = newValue;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Campo Telefone de Contato (opcional)
              TextFormField(
                controller: _telefoneContatoController,
                decoration: InputDecoration(
                  labelText: 'Telefone de Contato',
                  hintText: '(11) 99999-9999',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Campo opcional - com DDD',
                ),
                validator: _validarTelefone,
                keyboardType: TextInputType.phone,
                maxLength: 15,
              ),

              const SizedBox(height: 16),

              // Seção Redes Sociais
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.share, color: Colors.purple[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Redes Sociais (Opcional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Informe os perfis nas redes sociais (URL ou @username)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo Instagram
              TextFormField(
                controller: _perfilInstagramController,
                decoration: InputDecoration(
                  labelText: 'Instagram',
                  hintText: '@usuario ou https://instagram.com/usuario',
                  prefixIcon: const Icon(Icons.camera_alt, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo Facebook
              TextFormField(
                controller: _perfilFacebookController,
                decoration: InputDecoration(
                  labelText: 'Facebook',
                  hintText: 'https://facebook.com/usuario',
                  prefixIcon: const Icon(Icons.facebook, color: Colors.indigo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo TikTok
              TextFormField(
                controller: _perfilTiktokController,
                decoration: InputDecoration(
                  labelText: 'TikTok',
                  hintText: '@usuario ou https://tiktok.com/@usuario',
                  prefixIcon: const Icon(Icons.music_note, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Campo Ativo (Switch)
              Card(
                child: SwitchListTile(
                  title: const Text('Aluno Ativo'),
                  subtitle: Text(
                    _ativo
                        ? 'Este aluno estará ativo no sistema'
                        : 'Este aluno estará inativo',
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
                      onPressed: _salvarAluno,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
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
                          Text('Salvar Aluno'),
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

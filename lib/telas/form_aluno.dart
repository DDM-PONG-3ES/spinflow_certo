import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _telefoneController = TextEditingController();
  final _perfilInstagramController = TextEditingController();
  final _perfilFacebookController = TextEditingController();
  final _perfilTiktokController = TextEditingController();
  
  String? _generoSelecionado;
  bool _ativo = true;
  DateTime? _dataNascimentoSelecionada;

  final List<String> _generos = ['Masculino', 'Feminino', 'Outro', 'Prefiro não informar'];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _telefoneController.dispose();
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
    );
    
    if (!emailPattern.hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }
    
    // Remove caracteres não numéricos
    String numeroLimpo = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numeroLimpo.length < 10 || numeroLimpo.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

  String? _validarPerfilSocial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }
    
    // Validação básica para perfis sociais
    if (value.trim().length < 3) {
      return 'Perfil deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? _validarDataNascimento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    return null;
  }

  String? _validarGenero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gênero é obrigatório';
    }
    return null;
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimentoSelecionada ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    
    if (picked != null && picked != _dataNascimentoSelecionada) {
      setState(() {
        _dataNascimentoSelecionada = picked;
        _dataNascimentoController.text = 
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _salvarAluno() {
    if (_formKey.currentState!.validate()) {
      // Gerar ID simples (em produção, usar UUID ou similar)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      // Criar mapa com dados do aluno
      final aluno = {
        'id': id,
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'data_nascimento': _dataNascimentoSelecionada?.toIso8601String(),
        'genero': _generoSelecionado,
        'telefone_contato': _telefoneController.text.trim().isEmpty 
            ? null 
            : _telefoneController.text.trim(),
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
      };

      // Aqui você implementaria a lógica de salvamento
      print('Aluno salvo: $aluno');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aluno "${_nomeController.text}" salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Limpar formulário após salvar
      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _nomeController.clear();
    _emailController.clear();
    _dataNascimentoController.clear();
    _telefoneController.clear();
    _perfilInstagramController.clear();
    _perfilFacebookController.clear();
    _perfilTiktokController.clear();
    
    setState(() {
      _generoSelecionado = null;
      _ativo = true;
      _dataNascimentoSelecionada = null;
    });
  }

  void _voltarTela() {
    // Verificar se há dados não salvos
    bool temDados = _nomeController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _dataNascimentoController.text.isNotEmpty ||
        _telefoneController.text.isNotEmpty ||
        _perfilInstagramController.text.isNotEmpty ||
        _perfilFacebookController.text.isNotEmpty ||
        _perfilTiktokController.text.isNotEmpty ||
        _generoSelecionado != null;

    if (temDados) {
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
                  Navigator.of(context).pop(); // Fechar dialog
                  Navigator.of(context).pop(); // Voltar para dashboard
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
                            'Preencha os dados pessoais',
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

              // Campo Data de Nascimento (obrigatório)
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento *',
                  hintText: 'DD/MM/AAAA',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarDataNascimento,
                readOnly: true,
                onTap: _selecionarData,
              ),

              const SizedBox(height: 16),

              // Campo Gênero (obrigatório)
              DropdownButtonFormField<String>(
                value: _generoSelecionado,
                decoration: InputDecoration(
                  labelText: 'Gênero *',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarGenero,
                items: _generos.map((String genero) {
                  return DropdownMenuItem<String>(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (String? novoGenero) {
                  setState(() {
                    _generoSelecionado = novoGenero;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Campo Telefone (opcional)
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone de Contato',
                  hintText: '(11) 99999-9999',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Campo opcional',
                ),
                validator: _validarTelefone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),

              const SizedBox(height: 24),

              // Seção Redes Sociais
              Text(
                'Redes Sociais (Opcional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),

              // Campo Instagram
              TextFormField(
                controller: _perfilInstagramController,
                decoration: InputDecoration(
                  labelText: 'Perfil Instagram',
                  hintText: '@seu_usuario',
                  prefixIcon: const Icon(Icons.camera_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 50,
              ),

              const SizedBox(height: 16),

              // Campo Facebook
              TextFormField(
                controller: _perfilFacebookController,
                decoration: InputDecoration(
                  labelText: 'Perfil Facebook',
                  hintText: 'seu.nome.usuario',
                  prefixIcon: const Icon(Icons.facebook),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 50,
              ),

              const SizedBox(height: 16),

              // Campo TikTok
              TextFormField(
                controller: _perfilTiktokController,
                decoration: InputDecoration(
                  labelText: 'Perfil TikTok',
                  hintText: '@seu_usuario',
                  prefixIcon: const Icon(Icons.music_note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validarPerfilSocial,
                maxLength: 50,
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

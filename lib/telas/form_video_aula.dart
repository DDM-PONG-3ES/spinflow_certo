import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_video_aula.dart';

class FormVideoAula extends StatefulWidget {
  const FormVideoAula({super.key});

  @override
  State<FormVideoAula> createState() => _FormVideoAulaState();
}

class _FormVideoAulaState extends State<FormVideoAula> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _linkVideoController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _linkVideoController.dispose();
    super.dispose();
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? _validarUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo não obrigatório
    }

    // Validação básica de URL
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlPattern.hasMatch(value.trim())) {
      return 'URL inválida';
    }
    return null;
  }

  void _salvarVideoAula() {
    if (_formKey.currentState!.validate()) {
      // Gerar ID simples (em produção, usar UUID ou similar)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      // Criar instância do DTO
      final videoAula = DtoVideoAula(
        id: id,
        nome: _nomeController.text.trim(),
        linkVideo: _linkVideoController.text.trim().isEmpty
            ? null
            : _linkVideoController.text.trim(),
        ativo: _ativo,
      );

      // Aqui você implementaria a lógica de salvamento
      // Por exemplo: salvar no banco de dados, API, etc.
      print('VideoAula salva: ${videoAula.toMap()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('VideoAula "${_nomeController.text}" salva com sucesso!'),
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
    _linkVideoController.clear();
    setState(() {
      _ativo = true;
    });
  }

  void _voltarTela() {
    // Mostrar dialog de confirmação se houver dados não salvos
    if (_nomeController.text.isNotEmpty ||
        _linkVideoController.text.isNotEmpty) {
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
        title: const Text('Cadastro de VideoAula'),
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
                        Icons.video_library,
                        size: 32,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nova VideoAula',
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
                  labelText: 'Nome da VideoAula *',
                  hintText: 'Ex: Aula de Spinning Iniciante',
                  prefixIcon: const Icon(Icons.title),
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

              // Campo Link do Vídeo (opcional)
              TextFormField(
                controller: _linkVideoController,
                decoration: InputDecoration(
                  labelText: 'Link do Vídeo',
                  hintText: 'https://www.youtube.com/watch?v=...',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Campo opcional - deixe vazio se não tiver link',
                ),
                validator: _validarUrl,
                keyboardType: TextInputType.url,
                maxLines: 2,
                minLines: 1,
              ),

              const SizedBox(height: 16),

              // Campo Ativo (Switch)
              Card(
                child: SwitchListTile(
                  title: const Text('VideoAula Ativa'),
                  subtitle: Text(
                    _ativo
                        ? 'Esta videoaula estará disponível para uso'
                        : 'Esta videoaula estará inativa',
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
                      onPressed: _salvarVideoAula,
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
                          Text('Salvar VideoAula'),
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

import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_sala.dart';

class FormSala extends StatefulWidget {
  const FormSala({Key? key}) : super(key: key);

  @override
  _FormSalaState createState() => _FormSalaState();
}

class _FormSalaState extends State<FormSala> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _capacidadeController = TextEditingController();
  bool _disponivel = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _capacidadeController.dispose();
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

  String? _validarCapacidade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Capacidade não obrigatória
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Capacidade deve ser um número';
    }
    if (int.parse(value.trim()) <= 0) {
      return 'Capacidade deve ser maior que zero';
    }
    return null;
  }

  void _salvarSala() {
    if (_formKey.currentState!.validate()) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final sala = DtoSala(
        id: id,
        nome: _nomeController.text.trim(),
        capacidade: _capacidadeController.text.trim().isEmpty
            ? null
            : int.parse(_capacidadeController.text.trim()),
        disponivel: _disponivel,
      );

      print('Sala salva: ${sala.toMap()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sala "${_nomeController.text}" salva com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _nomeController.clear();
    _capacidadeController.clear();
    setState(() {
      _disponivel = true;
    });
  }

  void _voltarTela() {
    if (_nomeController.text.isNotEmpty ||
        _capacidadeController.text.isNotEmpty) {
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
        title: const Text('Cadastro de Sala'),
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
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.meeting_room,
                        size: 32,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nova Sala',
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
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Sala *',
                  hintText: 'Ex: Sala de Reuniões 1',
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
              TextFormField(
                controller: _capacidadeController,
                decoration: InputDecoration(
                  labelText: 'Capacidade',
                  hintText: 'Ex: 20',
                  prefixIcon: const Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText:
                      'Campo opcional - deixe vazio se não houver capacidade',
                ),
                validator: _validarCapacidade,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  title: const Text('Sala Disponível'),
                  subtitle: Text(
                    _disponivel
                        ? 'Esta sala está disponível para uso'
                        : 'Esta sala está indisponível',
                  ),
                  value: _disponivel,
                  onChanged: (value) {
                    setState(() {
                      _disponivel = value;
                    });
                  },
                  activeColor: Colors.green,
                  secondary: Icon(
                    _disponivel ? Icons.check_circle : Icons.cancel,
                    color: _disponivel ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                      onPressed: _salvarSala,
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
                          Text('Salvar Sala'),
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

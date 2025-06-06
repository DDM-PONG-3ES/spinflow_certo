import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/dto/dto_tipomanu.dart';

class FormTipoManutencao extends StatefulWidget {
  const FormTipoManutencao({Key? key}) : super(key: key);

  @override
  _FormTipoManutencaoState createState() => _FormTipoManutencaoState();
}

class _FormTipoManutencaoState extends State<FormTipoManutencao> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _custoController = TextEditingController();
  final _tempoHorasController = TextEditingController();
  final _tempoMinutosController = TextEditingController();

  int _prioridadeSelecionada = 2; // Média como padrão
  bool _ativo = true;

  final List<Map<String, dynamic>> _prioridades = [
    {
      'valor': 1,
      'texto': 'Baixa',
      'cor': Colors.green,
      'icone': Icons.keyboard_arrow_down
    },
    {'valor': 2, 'texto': 'Média', 'cor': Colors.orange, 'icone': Icons.remove},
    {
      'valor': 3,
      'texto': 'Alta',
      'cor': Colors.red,
      'icone': Icons.keyboard_arrow_up
    },
    {
      'valor': 4,
      'texto': 'Crítica',
      'cor': Colors.red[900],
      'icone': Icons.priority_high
    },
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _custoController.dispose();
    _tempoHorasController.dispose();
    _tempoMinutosController.dispose();
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

  String? _validarCusto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }

    final valorLimpo = value.replaceAll(',', '.');
    if (double.tryParse(valorLimpo) == null) {
      return 'Valor inválido';
    }

    final valor = double.parse(valorLimpo);
    if (valor < 0) {
      return 'Valor deve ser positivo';
    }

    return null;
  }

  String? _validarTempo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }

    if (int.tryParse(value) == null) {
      return 'Apenas números';
    }

    final valor = int.parse(value);
    if (valor < 0) {
      return 'Valor deve ser positivo';
    }

    return null;
  }

  int? _calcularTempoTotalMinutos() {
    final horas = int.tryParse(_tempoHorasController.text) ?? 0;
    final minutos = int.tryParse(_tempoMinutosController.text) ?? 0;

    if (horas == 0 && minutos == 0) return null;

    return (horas * 60) + minutos;
  }

  void _salvarTipoManutencao() {
    if (_formKey.currentState!.validate()) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final custoEstimado = _custoController.text.trim().isEmpty
          ? null
          : double.parse(_custoController.text.replaceAll(',', '.'));

      final tipoManutencao = DtoTipoManutencao(
        id: id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        prioridadeLevel: _prioridadeSelecionada,
        ativo: _ativo,
        custoEstimado: custoEstimado,
        tempoEstimadoMinutos: _calcularTempoTotalMinutos(),
      );

      print('Tipo Manutenção salvo: ${tipoManutencao.toMap()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tipo "${_nomeController.text}" salvo com sucesso!'),
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
    _custoController.clear();
    _tempoHorasController.clear();
    _tempoMinutosController.clear();
    setState(() {
      _prioridadeSelecionada = 2;
      _ativo = true;
    });
  }

  void _voltarTela() {
    final temDados = _nomeController.text.isNotEmpty ||
        _descricaoController.text.isNotEmpty ||
        _custoController.text.isNotEmpty ||
        _tempoHorasController.text.isNotEmpty ||
        _tempoMinutosController.text.isNotEmpty;

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
        title: const Text('Cadastro de Tipo Manutenção'),
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
              // Header Card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.build_circle,
                        size: 32,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Novo Tipo de Manutenção',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const Text(
                            'Defina os parâmetros do tipo de manutenção',
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

              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Tipo *',
                  hintText: 'Ex: Troca de Peça, Lubrificação',
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

              // Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva em detalhes este tipo de manutenção',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Prioridade
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nível de Prioridade',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _prioridades.map((prioridade) {
                          final isSelected =
                              _prioridadeSelecionada == prioridade['valor'];
                          return FilterChip(
                            selected: isSelected,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  prioridade['icone'],
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : prioridade['cor'],
                                ),
                                const SizedBox(width: 4),
                                Text(prioridade['texto']),
                              ],
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _prioridadeSelecionada = prioridade['valor'];
                              });
                            },
                            selectedColor: prioridade['cor'],
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tempo Estimado
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tempo Estimado (Opcional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tempoHorasController,
                              decoration: InputDecoration(
                                labelText: 'Horas',
                                hintText: '0',
                                suffixText: 'h',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: _validarTempo,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _tempoMinutosController,
                              decoration: InputDecoration(
                                labelText: 'Minutos',
                                hintText: '0',
                                suffixText: 'min',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: _validarTempo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Custo Estimado
              TextFormField(
                controller: _custoController,
                decoration: InputDecoration(
                  labelText: 'Custo Estimado (R\$)',
                  hintText: '0,00',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  helperText: 'Campo opcional - use vírgula para decimais',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validarCusto,
              ),
              const SizedBox(height: 16),

              // Status Ativo
              Card(
                child: SwitchListTile(
                  title: const Text('Tipo Ativo'),
                  subtitle: Text(
                    _ativo
                        ? 'Este tipo está disponível para uso'
                        : 'Este tipo está desabilitado',
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

              // Info obrigatórios
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

              // Botões
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
                      onPressed: _salvarTipoManutencao,
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
                          Text('Salvar Tipo'),
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

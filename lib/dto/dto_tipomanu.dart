class DtoTipoManutencao {
  final String id;
  final String nome;
  final String? descricao;
  final int prioridadeLevel; // 1=Baixa, 2=Média, 3=Alta, 4=Crítica
  final bool ativo;
  final double? custoEstimado;
  final int? tempoEstimadoMinutos;

  DtoTipoManutencao({
    required this.id,
    required this.nome,
    this.descricao,
    this.prioridadeLevel = 2, // Média como padrão
    this.ativo = true,
    this.custoEstimado,
    this.tempoEstimadoMinutos,
  });

  // Getter para prioridade em texto
  String get prioridadeTexto {
    switch (prioridadeLevel) {
      case 1:
        return 'Baixa';
      case 2:
        return 'Média';
      case 3:
        return 'Alta';
      case 4:
        return 'Crítica';
      default:
        return 'Média';
    }
  }

  // Getter para tempo formatado
  String get tempoEstimadoFormatado {
    if (tempoEstimadoMinutos == null) return 'Não definido';

    if (tempoEstimadoMinutos! < 60) {
      return '${tempoEstimadoMinutos}min';
    } else {
      final horas = tempoEstimadoMinutos! ~/ 60;
      final minutos = tempoEstimadoMinutos! % 60;
      return minutos > 0 ? '${horas}h ${minutos}min' : '${horas}h';
    }
  }

  // Getter para custo formatado
  String get custoEstimadoFormatado {
    if (custoEstimado == null) return 'Não definido';
    return 'R\$ ${custoEstimado!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Construtor para criar a partir de um Map
  factory DtoTipoManutencao.fromMap(Map<String, dynamic> map) {
    return DtoTipoManutencao(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      prioridadeLevel: map['prioridadeLevel'] ?? 2,
      ativo: map['ativo'] ?? true,
      custoEstimado: map['custoEstimado']?.toDouble(),
      tempoEstimadoMinutos: map['tempoEstimadoMinutos'],
    );
  }

  // Converter para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'prioridadeLevel': prioridadeLevel,
      'ativo': ativo,
      'custoEstimado': custoEstimado,
      'tempoEstimadoMinutos': tempoEstimadoMinutos,
    };
  }

  // Método para criar uma cópia com alterações
  DtoTipoManutencao copyWith({
    String? id,
    String? nome,
    String? descricao,
    int? prioridadeLevel,
    bool? ativo,
    double? custoEstimado,
    int? tempoEstimadoMinutos,
  }) {
    return DtoTipoManutencao(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      prioridadeLevel: prioridadeLevel ?? this.prioridadeLevel,
      ativo: ativo ?? this.ativo,
      custoEstimado: custoEstimado ?? this.custoEstimado,
      tempoEstimadoMinutos: tempoEstimadoMinutos ?? this.tempoEstimadoMinutos,
    );
  }

  @override
  String toString() {
    return 'DtoTipoManutencao{id: $id, nome: $nome, descricao: $descricao, '
        'prioridadeLevel: $prioridadeLevel, ativo: $ativo, '
        'custoEstimado: $custoEstimado, tempoEstimadoMinutos: $tempoEstimadoMinutos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoTipoManutencao &&
        other.id == id &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.prioridadeLevel == prioridadeLevel &&
        other.ativo == ativo &&
        other.custoEstimado == custoEstimado &&
        other.tempoEstimadoMinutos == tempoEstimadoMinutos;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        descricao.hashCode ^
        prioridadeLevel.hashCode ^
        ativo.hashCode ^
        custoEstimado.hashCode ^
        tempoEstimadoMinutos.hashCode;
  }
}

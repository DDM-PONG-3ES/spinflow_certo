class DtoSala {
  final String id;
  final String nome;
  final int? capacidade; // Nullable as it might not always be specified
  final bool disponivel;

  DtoSala({
    required this.id,
    required this.nome,
    this.capacidade,
    this.disponivel = true,
  });

  // Construtor para criar a partir de um Map (útil para JSON/Database)
  factory DtoSala.fromMap(Map<String, dynamic> map) {
    return DtoSala(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      capacidade: map['capacidade'],
      disponivel: map['disponivel'] ?? true,
    );
  }

  // Converter para Map (útil para salvar em JSON/Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'capacidade': capacidade,
      'disponivel': disponivel,
    };
  }

  // Método para criar uma cópia com alterações
  DtoSala copyWith({
    String? id,
    String? nome,
    int? capacidade,
    bool? disponivel,
  }) {
    return DtoSala(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      capacidade: capacidade ?? this.capacidade,
      disponivel: disponivel ?? this.disponivel,
    );
  }

  @override
  String toString() {
    return 'DtoSala{id: $id, nome: $nome, capacidade: $capacidade, disponivel: $disponivel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoSala &&
        other.id == id &&
        other.nome == nome &&
        other.capacidade == capacidade &&
        other.disponivel == disponivel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        capacidade.hashCode ^
        disponivel.hashCode;
  }
}

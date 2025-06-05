class DtoVideoAula {
  final String id;
  final String nome;
  final String? linkVideo;
  final bool ativo;

  DtoVideoAula({
    required this.id,
    required this.nome,
    this.linkVideo,
    this.ativo = true,
  });

  // Construtor para criar a partir de um Map (útil para JSON/Database)
  factory DtoVideoAula.fromMap(Map<String, dynamic> map) {
    return DtoVideoAula(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      linkVideo: map['link_video'],
      ativo: map['ativo'] ?? true,
    );
  }

  // Converter para Map (útil para salvar em JSON/Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'link_video': linkVideo,
      'ativo': ativo,
    };
  }

  // Método para criar uma cópia com alterações
  DtoVideoAula copyWith({
    String? id,
    String? nome,
    String? linkVideo,
    bool? ativo,
  }) {
    return DtoVideoAula(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      linkVideo: linkVideo ?? this.linkVideo,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  String toString() {
    return 'DtoVideoAula{id: $id, nome: $nome, linkVideo: $linkVideo, ativo: $ativo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoVideoAula &&
        other.id == id &&
        other.nome == nome &&
        other.linkVideo == linkVideo &&
        other.ativo == ativo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nome.hashCode ^ linkVideo.hashCode ^ ativo.hashCode;
  }
}

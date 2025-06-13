import 'package:flutter_application_1/dto/dto.dart';

class DTOFabricante extends DTO {
  final String? descricao;
  final String? nome_contato_principal;
  final String? email_contato;
  final String? telefone_contato;
  final bool ativo;

  DTOFabricante({
    super.id,
    required super.nome,
    this.descricao,
    this.nome_contato_principal,
    this.email_contato,
    this.telefone_contato,
    this.ativo = true,
  });

  // Método para converter para Map (útil para inserção no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'nome_contato_principal': nome_contato_principal,
      'email_contato': email_contato,
      'telefone_contato': telefone_contato,
      'ativo': ativo,
    };
  }

  // Método para criar instância a partir de Map (útil para consultas do banco)
  factory DTOFabricante.fromMap(Map<String, dynamic> map) {
    return DTOFabricante(
      id: map['id'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      nome_contato_principal: map['nome_contato_principal'],
      email_contato: map['email_contato'],
      telefone_contato: map['telefone_contato'],
      ativo: (map['ativo'] ?? 1) == 1,
    );
  }

  // Método para criar cópia com alterações
  DTOFabricante copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? nome_contato_principal,
    String? email_contato,
    String? telefone_contato,
    bool? ativo,
  }) {
    return DTOFabricante(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      nome_contato_principal: nome_contato_principal ?? this.nome_contato_principal,
      email_contato: email_contato ?? this.email_contato,
      telefone_contato: telefone_contato ?? this.telefone_contato,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  String toString() {
    return 'DTOFabricante(id: $id, nome: $nome, ativo: $ativo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DTOFabricante && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

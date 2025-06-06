import 'package:flutter_application_1/dto/dto_aluno.dart';

extension DTOAlunoExtension on DTOAluno {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'dataNascimento': dataNascimento,
      'genero': genero,
      'telefoneContato': telefoneContato,
      'perfilInstagram': perfilInstagram,
      'perfilFacebook': perfilFacebook,
      'perfilTiktok': perfilTiktok,
      'ativo': ativo,
    };
  }

  static DTOAluno fromMap(Map<String, dynamic> map) {
    return DTOAluno(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
      genero: map['genero'] ?? '',
      telefoneContato: map['telefoneContato'] ?? '',
      perfilInstagram: map['perfilInstagram'],
      perfilFacebook: map['perfilFacebook'],
      perfilTiktok: map['perfilTiktok'],
      ativo: map['ativo'] ?? true,
    );
  }

  bool isEmailValid() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isTelefoneValid() {
    return RegExp(r'^\(\d{2}\)\s\d{4,5}-\d{4}$').hasMatch(telefoneContato);
  }
}

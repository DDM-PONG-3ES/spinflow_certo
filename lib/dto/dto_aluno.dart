class DTOAluno {
  final int? id;
  final String nome;
  final String email;
  final String dataNascimento;
  final String genero;
  final String telefoneContato;
  final String? perfilInstagram;
  final String? perfilFacebook;
  final String? perfilTiktok;
  final bool ativo;

  DTOAluno({
    this.id,
    required this.nome,
    required this.email,
    required this.dataNascimento,
    required this.genero,
    required this.telefoneContato,
    this.perfilInstagram,
    this.perfilFacebook,
    this.perfilTiktok,
    this.ativo = true,
  });
}

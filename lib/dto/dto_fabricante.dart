class DTOFabricante {
  final int? id;
  final String nome;
  final String? descricao;
  final String nomeContatoPrincipal;
  final String emailContato;
  final String telefoneContato;
  final bool ativo;

  DTOFabricante({
    this.id,
    required this.nome,
    this.descricao,
    required this.nomeContatoPrincipal,
    required this.emailContato,
    required this.telefoneContato,
    this.ativo = true,
  });
}

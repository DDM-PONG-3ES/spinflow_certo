class DTOTipoManutencao {
  final int? id;
  final String nome;
  final String? descricao;
  final bool ativo;

  DTOTipoManutencao({
    this.id,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });
}

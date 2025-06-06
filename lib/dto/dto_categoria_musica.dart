class DTOCategoriaMusica {
  final int? id;
  final String nome;
  final String? descricao;
  final bool ativo;

  DTOCategoriaMusica({
    this.id,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });
}

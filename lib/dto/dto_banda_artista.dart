class DTOBandaArtista {
  final int? id;
  final String nome;
  final String? descricaoCurta;
  final String? linkRelacionado;
  final String? urlFotoPerfil;
  final bool ativo;

  DTOBandaArtista({
    this.id,
    required this.nome,
    this.descricaoCurta,
    this.linkRelacionado,
    this.urlFotoPerfil,
    this.ativo = true,
  });
}

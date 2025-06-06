class DTOMusica {
  final int? id;
  final String nome;
  final String artistaBandaId;
  final List<String> categoriasIds;
  final List<String> linksVideoAulasAssociadas;
  final int duracaoSegundos;
  final String? linkStreaming;
  final String? descricaoObservacoes;
  final bool ativo;

  DTOMusica({
    this.id,
    required this.nome,
    required this.artistaBandaId,
    required this.categoriasIds,
    required this.linksVideoAulasAssociadas,
    required this.duracaoSegundos,
    this.linkStreaming,
    this.descricaoObservacoes,
    this.ativo = true,
  });
}

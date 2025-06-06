class DTOMixAula {
  final int? id;
  final String nome;
  final String dataInicioValidade;
  final String dataFimValidade;
  final String? descricaoObservacoes;
  final List<String> musicasDoMixIds;
  final bool ativo;

  DTOMixAula({
    this.id,
    required this.nome,
    required this.dataInicioValidade,
    required this.dataFimValidade,
    this.descricaoObservacoes,
    required this.musicasDoMixIds,
    this.ativo = true,
  });
}

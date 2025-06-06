class DTOBike {
  final int? id;
  final String nome;
  final String numeroSerie;
  final String fabricanteId;
  final String dataAquisicao;
  final String dataCadastroSistema;
  final bool ativo;

  DTOBike({
    this.id,
    required this.nome,
    required this.numeroSerie,
    required this.fabricanteId,
    required this.dataAquisicao,
    required this.dataCadastroSistema,
    this.ativo = true,
  });
}

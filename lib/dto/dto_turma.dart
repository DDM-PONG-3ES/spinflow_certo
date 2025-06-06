class DTOTurma {
  final int? id;
  final String nome;
  final String? descricao;
  final String diasSemana;
  final String horaInicio;
  final int duracaoMinutos;
  final String salaId;
  final bool ativo;

  DTOTurma({
    this.id,
    required this.nome,
    this.descricao,
    required this.diasSemana,
    required this.horaInicio,
    required this.duracaoMinutos,
    required this.salaId,
    this.ativo = true,
  });
}

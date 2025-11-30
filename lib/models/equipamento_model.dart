class Equipamento {
  final int? id;
  final String nome;
  final String modelo;
  final String numeroSerie;
  final String fabricante;
  final String dataAquisicao;
  final String status;

  Equipamento({
    this.id,
    required this.nome,
    required this.modelo,
    required this.numeroSerie,
    required this.fabricante,
    required this.dataAquisicao,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'modelo': modelo,
      'numero_serie': numeroSerie,
      'fabricante': fabricante,
      'data_aquisicao': dataAquisicao,
      'status': status,
    };
  }

  factory Equipamento.fromJson(Map<String, dynamic> json) {
    return Equipamento(
      id: json['id'],
      nome: json['nome'] ?? '',
      modelo: json['modelo'] ?? '',
      numeroSerie: json['numero_serie'] ?? '',
      fabricante: json['fabricante'] ?? '',
      dataAquisicao: json['data_aquisicao'] ?? '',
      status: json['status'] ?? 'ativo',
    );
  }
}
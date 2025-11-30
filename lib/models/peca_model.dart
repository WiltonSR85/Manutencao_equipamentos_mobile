class Peca {
  final int? id;
  final String nome_da_peca;
  final String codigo;
  final String fabricante;
  final int? estoque;
  final String data_da_ultima_compra;

  Peca({
    this.id,
    required this.nome_da_peca,
    required this.codigo,
    required this.fabricante,
    this.estoque,
    required this.data_da_ultima_compra,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome_da_peca': nome_da_peca,
      'codigo': codigo,
      'fabricante': fabricante,
      'estoque': estoque,
      'data_da_ultima_compra': data_da_ultima_compra,
    };
  }

  factory Peca.fromJson(Map<String, dynamic> json) {
    return Peca(
      id: json['id'],
      nome_da_peca: json['nome_da_peca'] ?? '',
      codigo: json['codigo'] ?? '',
      fabricante: json['fabricante'] ?? '',
      estoque: json['estoque'],
      data_da_ultima_compra: json['data_da_ultima_compra'] ?? '',
    );
  }

}
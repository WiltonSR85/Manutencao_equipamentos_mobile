class Tecnico {
  final int? id;
  final String nome;
  final String especialidade;
  final String contato;
  final String certificacoes;

  Tecnico({
    this.id,
    required this.nome,
    required this.especialidade,
    required this.contato,
    required this.certificacoes,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'especialidade': especialidade,
      'contato': contato,
      'certificacoes': certificacoes,
    };
  }

  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      id: json['id'],
      nome: json['nome'] ?? '',
      especialidade: json['especialidade'] ?? '',
      contato: json['contato'] ?? '',
      certificacoes: json['certificacoes'] ?? '',
    );
  }
}
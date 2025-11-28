import 'package:flutter/material.dart';
import '../services/equipamento_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bem-vindo ao Dashboard!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _DashboardCard(title: 'Usuários', value: '10')),
                  SizedBox(width: 12),
                  Expanded(child: _DashboardCard(title: 'Ordens', value: '5')),
                  SizedBox(width: 12),
                  Expanded(child: _DashboardCard(title: 'Alertas', value: '2')),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Equipamentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: EquipamentoService().getEquipamentos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro ao carregar equipamentos');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Nenhum equipamento encontrado');
                  }
                  final equipamentos = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nome')),
                        DataColumn(label: Text('Modelo')),
                        DataColumn(label: Text('Nº Série')),
                        DataColumn(label: Text('Fabricante')),
                        DataColumn(label: Text('Data Aquisição')),
                      ],
                      rows: equipamentos.map((e) {
                        return DataRow(cells: [
                          DataCell(Text(e['id']?.toString() ?? '')),
                          DataCell(Text(e['nome'] ?? '')),
                          DataCell(Text(e['modelo'] ?? '')),
                          DataCell(Text(e['numero_serie'] ?? '')),
                          DataCell(Text(e['fabricante'] ?? '')),
                          DataCell(Text(e['data_aquisicao'] ?? '')),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const _DashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

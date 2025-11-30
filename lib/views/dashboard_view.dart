import 'package:flutter/material.dart';
import '../controllers/equipamento_controller.dart';
import '../models/equipamento_model.dart';
import './equipamento_form_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _controller = EquipamentoController();
  List<Equipamento> _equipamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEquipamentos();
  }

  Future<void> _loadEquipamentos() async {
    setState(() => _isLoading = true);
    final equipamentos = await _controller.getEquipamentos();
    setState(() {
      _equipamentos = equipamentos;
      _isLoading = false;
    });
  }

  Future<void> _deleteEquipamento(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir este equipamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _controller.deleteEquipamento(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Equipamento excluído com sucesso')),
        );
        _loadEquipamentos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir equipamento')),
        );
      }
    }
  }

  void _navigateToForm({Equipamento? equipamento}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipamentoFormView(equipamento: equipamento),
      ),
    );
    if (result == true) {
      _loadEquipamentos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Equipamento',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Equipamentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _loadEquipamentos,
                    tooltip: 'Atualizar',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _equipamentos.isEmpty
                      ? Text('Nenhum equipamento encontrado')
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Nome')),
                              DataColumn(label: Text('Modelo')),
                              DataColumn(label: Text('Nº Série')),
                              DataColumn(label: Text('Fabricante')),
                              DataColumn(label: Text('Data Aquisição')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Ações')),
                            ],
                            rows: _equipamentos.map((e) {
                              return DataRow(cells: [
                                DataCell(Text(e.id?.toString() ?? '')),
                                DataCell(Text(e.nome)),
                                DataCell(Text(e.modelo)),
                                DataCell(Text(e.numeroSerie)),
                                DataCell(Text(e.fabricante)),
                                DataCell(Text(e.dataAquisicao)),
                                DataCell(Text(e.status)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, size: 20),
                                        onPressed: () => _navigateToForm(equipamento: e),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () => _deleteEquipamento(e.id!),
                                        tooltip: 'Excluir',
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
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
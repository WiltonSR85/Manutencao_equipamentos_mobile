import 'package:flutter/material.dart';
import '../../../controllers/tecnico_controller.dart';
import '../../../models/tecnico_model.dart';
import '../../widgets/base_list_view.dart';
import '../../widgets/confirm_dialog.dart';
import './tecnico_form_screen.dart';

class TecnicoListScreen extends StatefulWidget {
  const TecnicoListScreen({super.key});

  @override
  State<TecnicoListScreen> createState() => _TecnicoListScreenState();
}

class _TecnicoListScreenState extends State<TecnicoListScreen> {
  final _controller = TecnicoController();
  List<Tecnico> _tecnicos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTecnicos();
  }

  Future<void> _loadTecnicos() async {
    setState(() => _isLoading = true);
    final tecnicos = await _controller.getTecnicos();
    setState(() {
      _tecnicos = tecnicos;
      _isLoading = false;
    });
  }

  Future<void> _deleteTecnico(int id) async {
    final confirm = await showConfirmDialog(
      context,
      'Confirmar Exclusão',
      'Deseja realmente excluir este técnico?',
    );

    if (confirm == true) {
      final success = await _controller.deleteTecnico(id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Técnico excluído com sucesso')),
          );
          _loadTecnicos();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir técnico')),
          );
        }
      }
    }
  }

  void _navigateToForm({Tecnico? tecnico}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TecnicoFormScreen(tecnico: tecnico),
      ),
    );
    if (result == true) {
      _loadTecnicos();
    }
  }

  List<DataColumn> _getColumns() {
    return const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Especialidade')),
      DataColumn(label: Text('Contato')),
      DataColumn(label: Text('Certificações')),
      DataColumn(label: Text('Ações')),
    ];
  }

  List<DataCell> _buildDataCells(Tecnico p, BuildContext context) {
    return [
      DataCell(Text(p.id?.toString() ?? '')),
      DataCell(Text(p.nome)),
      DataCell(Text(p.especialidade)),
      DataCell(Text(p.contato)),
      DataCell(Text(p.certificacoes)),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _navigateToForm(tecnico: p),
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteTecnico(p.id!),
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BaseListView<Tecnico>(
          data: _tecnicos,
          columns: _getColumns(),
          rowBuilder: _buildDataCells,
          onRefresh: _loadTecnicos,
          isLoading: _isLoading,
          emptyMessage: 'Nenhum técnico cadastrado.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Adicionar Técnico',
        child: const Icon(Icons.add),
      ),
    );
  }
}
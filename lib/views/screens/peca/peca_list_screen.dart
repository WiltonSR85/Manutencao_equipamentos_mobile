import 'package:flutter/material.dart';
import '../../../controllers/peca_controller.dart';
import '../../../models/peca_model.dart';
import '../../widgets/base_list_view.dart';
import '../../widgets/confirm_dialog.dart';
import './peca_form_screen.dart';

class PecaListScreen extends StatefulWidget {
  const PecaListScreen({super.key});

  @override
  State<PecaListScreen> createState() => _PecaListScreenState();
}

class _PecaListScreenState extends State<PecaListScreen> {
  final _controller = PecaContrller();
  List<Peca> _pecas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPecas();
  }

  Future<void> _loadPecas() async {
    setState(() => _isLoading = true);
    final pecas = await _controller.getPecas();
    setState(() {
      _pecas = pecas;
      _isLoading = false;
    });
  }

  Future<void> _deletePeca(int id) async {
    final confirm = await showConfirmDialog(
      context,
      'Confirmar Exclusão',
      'Deseja realmente excluir esta peça?',
    );

    if (confirm == true) {
      final success = await _controller.deletePeca(id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Peça excluída com sucesso')),
          );
          _loadPecas();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir peça')),
          );
        }
      }
    }
  }

  void _navigateToForm({Peca? peca}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PecaFormScreen(peca: peca),
      ),
    );
    if (result == true) {
      _loadPecas();
    }
  }

  List<DataColumn> _getColumns() {
    return const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Código')),
      DataColumn(label: Text('Fabricante')),
      DataColumn(label: Text('Estoque')),
      DataColumn(label: Text('Última Compra')),
      DataColumn(label: Text('Ações')),
    ];
  }

  List<DataCell> _buildDataCells(Peca p, BuildContext context) {
    return [
      DataCell(Text(p.id?.toString() ?? '')),
      DataCell(Text(p.nome_da_peca)),
      DataCell(Text(p.codigo)),
      DataCell(Text(p.fabricante)),
      DataCell(Text(p.estoque?.toString() ?? '0')),
      DataCell(Text(p.data_da_ultima_compra)),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _navigateToForm(peca: p),
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deletePeca(p.id!),
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
        child: BaseListView<Peca>(
          data: _pecas,
          columns: _getColumns(),
          rowBuilder: _buildDataCells,
          onRefresh: _loadPecas,
          isLoading: _isLoading,
          emptyMessage: 'Nenhuma peça cadastrada.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Adicionar Peça',
        child: const Icon(Icons.add),
      ),
    );
  }
}
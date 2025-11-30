import 'package:flutter/material.dart';

typedef DataRowBuilder<T> = List<DataCell> Function(T item, BuildContext context);

class BaseListView<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final DataRowBuilder<T> rowBuilder;
  final VoidCallback onRefresh;
  final bool isLoading;
  final String emptyMessage;

  const BaseListView({
    super.key,
    required this.data,
    required this.columns,
    required this.rowBuilder,
    required this.onRefresh,
    this.isLoading = false,
    this.emptyMessage = 'Nenhum item encontrado',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lista de Itens',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              tooltip: 'Atualizar',
            ),
          ],
        ),
        const SizedBox(height: 16),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : data.isEmpty
                ? Center(child: Text(emptyMessage, style: TextStyle(color: Colors.grey[600])))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: columns,
                      rows: data.map((item) {
                        return DataRow(cells: rowBuilder(item, context));
                      }).toList(),
                    ),
                  ),
      ],
    );
  }
}
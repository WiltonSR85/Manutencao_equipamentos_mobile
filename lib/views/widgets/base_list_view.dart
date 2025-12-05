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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lista de Itens',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRefresh,
                  tooltip: 'Atualizar',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        Expanded(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Carregando...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            emptyMessage,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.grey[200],
                              ),
                              child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor.withOpacity(0.08),
                              ),
                              headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              dataRowHeight: 60,
                              headingRowHeight: 56,
                              columnSpacing: 24,
                              horizontalMargin: 20,
                              dataTextStyle: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              columns: columns.map((column) {
                                return DataColumn(
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: column.label,
                                  ),
                                );
                              }).toList(),
                              rows: data.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.04);
                                      }
                                      if (index.isEven) {
                                        return Colors.grey[50];
                                      }
                                      return null;
                                    },
                                  ),
                                  cells: rowBuilder(item, context),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
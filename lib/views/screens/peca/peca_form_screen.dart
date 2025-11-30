import 'package:flutter/material.dart';
import '../../../controllers/peca_controller.dart';
import '../../../models/peca_model.dart';
import '../../widgets/base_form_field.dart';

class PecaFormScreen extends StatefulWidget {
  final Peca? peca;

  const PecaFormScreen({super.key, this.peca});

  @override
  State<PecaFormScreen> createState() => _PecaFormScreenState();
}

class _PecaFormScreenState extends State<PecaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = PecaContrller();

  late TextEditingController _nomeController;
  late TextEditingController _codigoController;
  late TextEditingController _fabricanteController;
  late TextEditingController _estoqueController;
  late TextEditingController _dataUltimaCompraController;

  bool get _isEditing => widget.peca != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.peca?.nome_da_peca ?? '');
    _codigoController = TextEditingController(text: widget.peca?.codigo ?? '');
    _fabricanteController = TextEditingController(text: widget.peca?.fabricante ?? '');
    _estoqueController = TextEditingController(text: widget.peca?.estoque?.toString() ?? '');
    _dataUltimaCompraController = TextEditingController(text: widget.peca?.data_da_ultima_compra ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _fabricanteController.dispose();
    _estoqueController.dispose();
    _dataUltimaCompraController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Formato AAAA-MM-DD
      setState(() {
        _dataUltimaCompraController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final peca = Peca(
        id: widget.peca?.id,
        nome_da_peca: _nomeController.text,
        codigo: _codigoController.text,
        fabricante: _fabricanteController.text,
        estoque: int.tryParse(_estoqueController.text),
        data_da_ultima_compra: _dataUltimaCompraController.text,
      );

      bool success;
      if (_isEditing) {
        success = await _controller.updatePeca(widget.peca!.id!, peca);
      } else {
        success = await _controller.createPeca(peca);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isEditing ? 'Peça atualizada com sucesso' : 'Peça criada com sucesso')),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar peça')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Peça' : 'Nova Peça'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              BaseFormField(
                controller: _nomeController,
                labelText: 'Nome da Peça',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _codigoController,
                labelText: 'Código',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _fabricanteController,
                labelText: 'Fabricante',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _estoqueController,
                labelText: 'Estoque',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obrigatório';
                  if (int.tryParse(value) == null) return 'Deve ser um número inteiro';
                  return null;
                },
              ),
              BaseFormField(
                controller: _dataUltimaCompraController,
                labelText: 'Data da Última Compra (AAAA-MM-DD)',
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _save,
                child: Text(_isEditing ? 'Atualizar Peça' : 'Criar Peça', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
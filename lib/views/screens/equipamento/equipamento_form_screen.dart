import 'package:flutter/material.dart';
import '../../../controllers/equipamento_controller.dart';
import '../../../models/equipamento_model.dart';
import '../../widgets/base_form_field.dart';

class EquipamentoFormScreen extends StatefulWidget {
  final Equipamento? equipamento;

  const EquipamentoFormScreen({super.key, this.equipamento});

  @override
  State<EquipamentoFormScreen> createState() => _EquipamentoFormScreenState();
}
class _EquipamentoFormScreenState extends State<EquipamentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EquipamentoController();

  late TextEditingController _nomeController;
  late TextEditingController _modeloController;
  late TextEditingController _numeroSerieController;
  late TextEditingController _fabricanteController;
  late TextEditingController _dataAquisicaoController;
  String _status = 'ativo';

  bool get _isEditing => widget.equipamento != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.equipamento?.nome ?? '');
    _modeloController = TextEditingController(text: widget.equipamento?.modelo ?? '');
    _numeroSerieController = TextEditingController(text: widget.equipamento?.numeroSerie ?? '');
    _fabricanteController = TextEditingController(text: widget.equipamento?.fabricante ?? '');
    _dataAquisicaoController = TextEditingController(text: widget.equipamento?.dataAquisicao ?? '');
    _status = widget.equipamento?.status ?? 'ativo';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _modeloController.dispose();
    _numeroSerieController.dispose();
    _fabricanteController.dispose();
    _dataAquisicaoController.dispose();
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
      setState(() {
        _dataAquisicaoController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final equipamento = Equipamento(
        id: widget.equipamento?.id,
        nome: _nomeController.text,
        modelo: _modeloController.text,
        numeroSerie: _numeroSerieController.text,
        fabricante: _fabricanteController.text,
        dataAquisicao: _dataAquisicaoController.text,
        status: _status,
      );

      bool success;
      if (_isEditing) {
        success = await _controller.updateEquipamento(widget.equipamento!.id!, equipamento);
      } else {
        success = await _controller.createEquipamento(equipamento);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isEditing ? 'Equipamento atualizado com sucesso' : 'Equipamento criado com sucesso')),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar equipamento')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Equipamento' : 'Novo Equipamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              BaseFormField(
                controller: _nomeController,
                labelText: 'Nome',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _modeloController,
                labelText: 'Modelo',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _numeroSerieController,
                labelText: 'Número de Série',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _fabricanteController,
                labelText: 'Fabricante',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _dataAquisicaoController,
                labelText: 'Data de Aquisição (AAAA-MM-DD)',
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'inativo', child: Text('Inativo')),
                  DropdownMenuItem(value: 'manutencao', child: Text('Em manutenção')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _save,
                child: Text(_isEditing ? 'Atualizar Equipamento' : 'Criar Equipamento', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
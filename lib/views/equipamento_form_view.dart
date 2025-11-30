import 'package:flutter/material.dart';
import '../controllers/equipamento_controller.dart';
import '../models/equipamento_model.dart';

class EquipamentoFormView extends StatefulWidget {
  final Equipamento? equipamento;

  const EquipamentoFormView({Key? key, this.equipamento}) : super(key: key);

  @override
  State<EquipamentoFormView> createState() => _EquipamentoFormViewState();
}

class _EquipamentoFormViewState extends State<EquipamentoFormView> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Equipamento atualizado com sucesso' : 'Equipamento criado com sucesso')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar equipamento')),
        );
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
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _numeroSerieController,
                decoration: InputDecoration(labelText: 'Número de Série'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fabricanteController,
                decoration: InputDecoration(labelText: 'Fabricante'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dataAquisicaoController,
                decoration: InputDecoration(
                  labelText: 'Data de Aquisição (AAAA-MM-DD)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(value: 'ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'inativo', child: Text('Inativo')),
                  DropdownMenuItem(value: 'manutencao', child: Text('Em manutenção')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(_isEditing ? 'Atualizar' : 'Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
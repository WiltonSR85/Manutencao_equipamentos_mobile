import 'package:flutter/material.dart';
import '../../../controllers/tecnico_controller.dart';
import '../../../models/tecnico_model.dart';
import '../../widgets/base_form_field.dart';
 
class TecnicoFormScreen extends StatefulWidget {
  final Tecnico? tecnico;

  const TecnicoFormScreen({super.key, this.tecnico});

  @override
  State<TecnicoFormScreen> createState() => _TecnicoFormScreenState();
}

class _TecnicoFormScreenState extends State<TecnicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TecnicoContrller();

  late TextEditingController _nomeController;
  late TextEditingController _especialidadeController;
  late TextEditingController _contatoController;
  late TextEditingController _certificacoesController;

  bool get _isEditing => widget.tecnico != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tecnico?.nome ?? '');
    _especialidadeController = TextEditingController(text: widget.tecnico?.especialidade ?? '');
    _contatoController = TextEditingController(text: widget.tecnico?.contato ?? '');
    _certificacoesController = TextEditingController(text: widget.tecnico?.certificacoes ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    _contatoController.dispose();
    _certificacoesController.dispose();
    super.dispose();
  }


  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final tecnico = Tecnico(
        id: widget.tecnico?.id,
        nome: _nomeController.text,
        especialidade: _especialidadeController.text,
        contato: _contatoController.text,
        certificacoes: _certificacoesController.text,
      );

      bool success;
      if (_isEditing) {
        success = await _controller.updateTecnico(widget.tecnico!.id!, tecnico);
      } else {
        success = await _controller.createTecnico(tecnico);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isEditing ? 'Técnico atualizado com sucesso' : 'Técnico criado com sucesso')),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar técnico')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Técnico' : 'Nova Técnico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              BaseFormField(
                controller: _nomeController,
                labelText: 'Nome do Técnico',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _especialidadeController,
                labelText: 'Especialidade',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _contatoController,
                labelText: 'Contato',
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              BaseFormField(
                controller: _certificacoesController,
                labelText: 'Certificações',
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
                child: Text(_isEditing ? 'Atualizar Técnico' : 'Criar Técnico', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
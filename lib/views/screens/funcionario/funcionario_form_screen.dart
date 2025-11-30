import 'package:flutter/material.dart';

class FuncionarioFormScreen extends StatelessWidget {
  // final Funcionario? funcionario;
  
  const FuncionarioFormScreen({super.key/*, this.funcionario*/});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Funcionário (A implementar)'),
      ),
      body: const Center(
        child: Text('Formulário de Funcionário'),
      ),
    );
  }
}
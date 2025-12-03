import 'package:flutter/material.dart';
import './equipamento/equipamento_list_screen.dart';
import './peca/peca_list_screen.dart';
import './tecnico/tecnico_list_screen.dart';
import '../../services/auth_service.dart';
import '../screens/login_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    WelcomeScreen(),
    EquipamentoListScreen(),
    PecaListScreen(),
    TecnicoListScreen(),
  ];

  static const List<BottomNavigationBarItem> _navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Início',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.build),
      label: 'Equipamentos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.storage),
      label: 'Peças',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Técnicos',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navBarItems[_selectedIndex].label ?? 'Gerenciamento'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.engineering,
              size: 120,
              color: primaryColor.withOpacity(0.8),
            ),
            const SizedBox(height: 24),

            Text(
              'Bem-vindo ao Sistema de Gestão de Equipamentos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Sua plataforma integrada para gerenciar equipamentos, peças e técnicos de forma eficiente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'O que você deseja gerenciar?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Use o menu de navegação abaixo para acessar as listas de Equipamentos, Peças e Técnicos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Image.asset(
              'assets/logo_empresa.png',
              height: 50,
              errorBuilder: (context, error, stackTrace) => Text(
                'Sistema de Manutenção 2.0',
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
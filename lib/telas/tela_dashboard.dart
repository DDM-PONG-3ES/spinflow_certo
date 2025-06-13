import 'package:flutter/material.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Professora'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Visão Geral'),
            Tab(text: 'Cadastros'),
            Tab(text: 'Aulas'),
            Tab(text: 'Manutenção'),
            Tab(text: 'Recados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _visaoGeral(),
          _cadastros(),
          _aulasEAuloes(),
          _manutencao(),
          _recados(),
        ],
      ),
    );
  }

  Widget _visaoGeral() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _infoCard(
            icon: Icons.message,
            value: '3',
            title: 'Recados',
            color: Colors.orange,
          ),
          _infoCard(
            icon: Icons.person,
            value: '82',
            title: 'Alunos Ativos',
            color: Colors.green,
          ),
          _infoCard(
            icon: Icons.schedule,
            value: '12',
            title: 'Aulas Agendadas',
            color: Colors.blue,
          ),
          _infoCard(
            icon: Icons.music_note,
            value: '4',
            title: 'Mix de Músicas',
            color: Colors.purple,
          ),
          _infoCard(
            icon: Icons.directions_bike,
            value: '18',
            title: 'Bikes OK',
            color: Colors.teal,
          ),
          _infoCard(
            icon: Icons.meeting_room,
            value: '5',
            title: 'Salas Ativas',
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String value,
    required String title,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cadastros() {
    final List<Map<String, dynamic>> cadastroItems = [
      {
        'title': 'Vídeo Aula',
        'icon': Icons.video_library,
        'route': '/video-aula',
      },      {'title': 'Aluno', 'icon': Icons.person, 'route': ''},
      {'title': 'Fabricante', 'icon': Icons.business, 'route': '/fabricante'},
      {'title': 'Lista Fabricantes', 'icon': Icons.list, 'route': '/lista-fabricante'},
      {
        'title': 'Sala',
        'icon': Icons.meeting_room,
        'route': '/sala', // Adicionada rota para sala
      },
      {
        'title': 'Tipo Manutenção',
        'icon': Icons.build,
        'route': '/tipomanu',
      },
      {'title': 'Categoria Música', 'icon': Icons.category, 'route': ''},
      {'title': 'Banda Artista', 'icon': Icons.group, 'route': ''},
      {'title': 'Turma', 'icon': Icons.school, 'route': ''},
      {'title': 'Bike', 'icon': Icons.directions_bike, 'route': ''},
      {'title': 'Música', 'icon': Icons.music_note, 'route': ''},
      {
        'title': 'Mix Aula (Playlist)',
        'icon': Icons.playlist_play,
        'route': ''
      },
      {'title': 'Grupo Aluno', 'icon': Icons.groups, 'route': ''},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cadastroItems.length,
      itemBuilder: (context, index) {
        final item = cadastroItems[index];
        return _cadastroTile(
          title: item['title'],
          icon: item['icon'],
          route: item['route'],
        );
      },
    );
  }

  Widget _aulasEAuloes() {
    final List<Map<String, dynamic>> aulaItems = [
      {'title': 'Agendar Nova Aula', 'icon': Icons.add_circle, 'route': ''},
      {'title': 'Aulas de Hoje', 'icon': Icons.today, 'route': ''},
      {'title': 'Próximas Aulas', 'icon': Icons.schedule, 'route': ''},
      {'title': 'Histórico de Aulas', 'icon': Icons.history, 'route': ''},
      {'title': 'Aulões Especiais', 'icon': Icons.star, 'route': ''},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: aulaItems.length,
      itemBuilder: (context, index) {
        final item = aulaItems[index];
        return _cadastroTile(
          title: item['title'],
          icon: item['icon'],
          route: item['route'],
        );
      },
    );
  }

  Widget _manutencao() {
    final List<Map<String, dynamic>> manutencaoItems = [
      {
        'title': 'Solicitar Manutenção',
        'icon': Icons.build_circle,
        'route': ''
      },
      {'title': 'Bikes em Manutenção', 'icon': Icons.engineering, 'route': ''},
      {'title': 'Histórico Manutenções', 'icon': Icons.history, 'route': ''},
      {'title': 'Relatório de Status', 'icon': Icons.assessment, 'route': ''},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: manutencaoItems.length,
      itemBuilder: (context, index) {
        final item = manutencaoItems[index];
        return _cadastroTile(
          title: item['title'],
          icon: item['icon'],
          route: item['route'],
        );
      },
    );
  }

  Widget _recados() {
    final List<Map<String, dynamic>> recadoItems = [
      {'title': 'Novo Recado', 'icon': Icons.add_comment, 'route': ''},
      {'title': 'Recados Enviados', 'icon': Icons.send, 'route': ''},
      {'title': 'Recados Recebidos', 'icon': Icons.inbox, 'route': ''},
      {'title': 'Avisos Gerais', 'icon': Icons.announcement, 'route': ''},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: recadoItems.length,
      itemBuilder: (context, index) {
        final item = recadoItems[index];
        return _cadastroTile(
          title: item['title'],
          icon: item['icon'],
          route: item['route'],
        );
      },
    );
  }

  Widget _cadastroTile({
    required String title,
    required IconData icon,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(
            icon,
            color: Colors.blue[700],
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),        onTap: () {
          if (route.isNotEmpty) {
            Navigator.pushNamed(context, route);
          } else {
            if (title == 'Vídeo Aula') {
              Navigator.pushNamed(context, '/video-aula');
            } else if (title == 'Aluno') {
              Navigator.pushNamed(context, '/aluno');
            } else {
              // Navegação temporária desabilitada - rota vazia
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Funcionalidade "$title" em desenvolvimento'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

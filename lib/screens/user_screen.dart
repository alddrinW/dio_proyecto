import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial en modo normal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users - Manejo de Estados')),
      body: Column(
        children: [
          // ── Botones de prueba para forzar estados ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                  onPressed: () {
                    final provider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    provider.debugForceState = 'loading';
                    provider.fetchUsers();
                  },
                  child: const Text('Forzar Loading'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () {
                    final provider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    provider.debugForceState = 'success';
                    provider.fetchUsers();
                  },
                  child: const Text('Forzar Success'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                  ),
                  onPressed: () {
                    final provider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    provider.debugForceState = 'empty';
                    provider.fetchUsers();
                  },
                  child: const Text('Forzar Empty'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                  onPressed: () {
                    final provider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    provider.debugForceState = 'error';
                    provider.fetchUsers();
                  },
                  child: const Text('Forzar Error'),
                ),
                OutlinedButton(
                  onPressed: () {
                    final provider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    provider.debugForceState = '';
                    provider.fetchUsers();
                  },
                  child: const Text('Modo Normal (aleatorio)'),
                ),
              ],
            ),
          ),

          // ── Contenido principal según estado ──────────────────────────────────
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case UserState.loading:
                    return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                          title: Container(height: 12, color: Colors.white),
                          subtitle: Container(height: 10, color: Colors.white),
                        ),
                      ),
                    );

                  case UserState.success:
                    return ListView.builder(
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(user.id.toString()),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: Text(user.username),
                        );
                      },
                    );

                  case UserState.empty:
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );

                  case UserState.error:
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 80,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${provider.errorMessage}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () => provider.fetchUsers(),
                            ),
                          ],
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

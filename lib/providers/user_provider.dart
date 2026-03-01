import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

enum UserState { loading, success, empty, error }

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserState _state = UserState.loading;
  List<User> _users = [];
  String _errorMessage = '';

  // ← Variable para forzar estados manualmente (¡esto es lo nuevo!)
  String debugForceState =
      ''; // valores: 'loading', 'success', 'empty', 'error', '' (modo normal)

  UserState get state => _state;
  List<User> get users => _users;
  String get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _state = UserState.loading;
    _errorMessage = ''; // Limpiamos error anterior
    notifyListeners();

    // Si hay un estado forzado → lo aplicamos directamente
    if (debugForceState.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2)); // Simula tiempo de red

      switch (debugForceState.toLowerCase()) {
        case 'loading':
          // Se queda en loading indefinidamente (para ver shimmer todo el tiempo)
          // No cambiamos estado ni notificamos más
          return;

        case 'success':
          _users = [
            User(
              id: 999,
              name: "Alddrin Prueba",
              username: "alddrin_dev",
              email: "alddrin@example.com",
            ),
            User(
              id: 1000,
              name: "Usuario Demo",
              username: "demo_user",
              email: "demo@example.com",
            ),
            User(
              id: 1001,
              name: "Flutter Master",
              username: "flutter_pro",
              email: "flutter@example.com",
            ),
          ];
          _state = UserState.success;
          break;

        case 'empty':
          _users = [];
          _state = UserState.empty;
          break;

        case 'error':
          _errorMessage =
              "Error simulado (puede ser 500 Server Error o 401 Unauthorized)";
          _state = UserState.error;
          break;

        default:
          // Si ponen algo raro → volvemos a modo normal
          debugForceState = '';
      }

      notifyListeners();
      return; // Terminamos aquí si forzamos
    }

    // Modo normal: usamos la API real + interceptor aleatorio
    try {
      final data = await _apiService.fetchUsers();

      if (data.isEmpty) {
        _state = UserState.empty;
      } else {
        _users = data.map((json) => User.fromJson(json)).toList();
        _state = UserState.success;
      }
    } catch (e) {
      _errorMessage = e.toString().length > 200
          ? "${e.toString().substring(0, 200)}..." // Acortamos mensajes muy largos
          : e.toString();
      _state = UserState.error;
    }

    notifyListeners();
  }
}

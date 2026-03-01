import 'dart:math';
import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
    _dio.interceptors.add(_customInterceptor());
  }

  Interceptor _customInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Añadir retraso aleatorio de 1 a 4 segundos
        final randomDelay = Random().nextInt(4) + 1;
        await Future.delayed(Duration(seconds: randomDelay));

        // 20% de chance de error
        final randomError = Random().nextDouble();
        if (randomError < 0.2) {
          // Aleatoriamente elegir entre 500 o 401
          final errorCode = Random().nextBool() ? 500 : 401;
          return handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: errorCode,
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        }

        // Para simular Empty: 10% de chance de respuesta vacía (ajusta si necesario)
        final randomEmpty = Random().nextDouble();
        if (randomEmpty < 0.1) {
          return handler.resolve(
            Response(
              requestOptions: options,
              data: [], // Respuesta vacía
              statusCode: 200,
            ),
          );
        }

        return handler.next(options);
      },
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await _dio.get('/users');
    return response.data;
  }
}

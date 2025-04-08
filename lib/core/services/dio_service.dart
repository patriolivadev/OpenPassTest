import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class DioServiceBase {
  final Dio dio;

  DioServiceBase({required this.dio});

  Future<dynamic> get(String url);
}

@Injectable(as: DioServiceBase)
class DioService extends DioServiceBase {
  DioService({required super.dio});

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en la solicitud GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Excepción durante la solicitud GET: $e');
    }
  }
}

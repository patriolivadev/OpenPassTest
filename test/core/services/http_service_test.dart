import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dio_service.dart';

import 'http_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late DioService httpService;

  setUp(() {
    mockDio = MockDio();
    httpService = DioService(dio: mockDio);
  });

  group('HttpService', () {
    const tUrl = 'https://example.com/api/data';
    final tResponseJson = {'key': 'value'};

    test('debe realizar una solicitud GET exitosa y retornar el cuerpo decodificado', () async {
      when(mockDio.get(tUrl)).thenAnswer(
            (_) async => Response(
          data: tResponseJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: tUrl),
        ),
      );

      final result = await httpService.get(tUrl);

      verify(mockDio.get(tUrl)).called(1);
      expect(result, tResponseJson);
    });

    test('debe lanzar una excepción si el código de estado no es 200', () async {
      when(mockDio.get(tUrl)).thenAnswer(
            (_) async => Response(
          data: 'Error',
          statusCode: 404,
          requestOptions: RequestOptions(path: tUrl),
        ),
      );

      expect(
            () => httpService.get(tUrl),
        throwsA(isA<Exception>()),
      );

      verify(mockDio.get(tUrl)).called(1);
    });

    test('debe lanzar una excepción si ocurre un error durante la solicitud', () async {
      when(mockDio.get(tUrl)).thenThrow(Exception('Error de red'));

      expect(
            () => httpService.get(tUrl),
        throwsA(isA<Exception>()),
      );

      verify(mockDio.get(tUrl)).called(1);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_pass_test_oliva_patricio/core/services/http_service.dart';

import 'http_service_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient mockClient;
  late HttpService httpService;

  setUp(() {
    mockClient = MockClient();
    httpService = HttpService(http: mockClient);
  });

  group('HttpService', () {
    const tUrl = 'https://example.com/api/data';
    final tResponseJson = {'key': 'value'};

    test('debe realizar una solicitud GET exitosa y retornar el cuerpo decodificado', () async {
      when(mockClient.get(Uri.parse(tUrl))).thenAnswer(
            (_) async => Response(json.encode(tResponseJson), 200),
      );

      final result = await httpService.get(tUrl);

      verify(mockClient.get(Uri.parse(tUrl))).called(1);
      expect(result, tResponseJson);
    });

    test('debe lanzar una excepción si el código de estado no es 200', () async {
      when(mockClient.get(Uri.parse(tUrl))).thenAnswer(
            (_) async => Response('Error', 404),
      );

      expect(
            () => httpService.get(tUrl),
        throwsA(isA<Exception>()),
      );

      verify(mockClient.get(Uri.parse(tUrl))).called(1);
    });

    test('debe lanzar una excepción si ocurre un error durante la solicitud', () async {
      when(mockClient.get(Uri.parse(tUrl))).thenThrow(Exception('Error de red'));

      expect(
            () => httpService.get(tUrl),
        throwsA(isA<Exception>()),
      );

      verify(mockClient.get(Uri.parse(tUrl))).called(1);
    });
  });
}

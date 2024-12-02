import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/core/services/http_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_remote_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';

import 'character_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpServiceBase, CharacterLocalDataSourceBase])
void main() {
  late MockHttpServiceBase mockHttpService;
  late MockCharacterLocalDataSourceBase mockLocalDataSource;
  late CharacterRemoteDataSource dataSource;

  setUp(() {
    mockHttpService = MockHttpServiceBase();
    mockLocalDataSource = MockCharacterLocalDataSourceBase();
    dataSource = CharacterRemoteDataSource(
      http: mockHttpService,
      local: mockLocalDataSource,
    );
  });

  group('getCharacters', () {
    final tFilter = Filter(name: 'Luke', index: 1);
    const tUrl = 'https://swapi.dev/api/people/?search=Luke&page=1';

    test('debe retornar CharactersResponse correctamente', () async {
      final tResponseJson = {
        'results': [
          {'name': 'Luke Skywalker', 'url': 'https://swapi.dev/api/people/1/'},
          {'name': 'Leia Organa', 'url': 'https://swapi.dev/api/people/2/'},
        ],
        'count': 2
      };

      final tCharacterModels = [
        CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true),
        CharacterModel(id: 2, name: 'Leia Organa', isFavorite: false),
      ];

      when(mockHttpService.get(tUrl)).thenAnswer((_) async => tResponseJson);
      when(mockLocalDataSource.isCharacterSaved(1)).thenAnswer((_) async => true);
      when(mockLocalDataSource.isCharacterSaved(2)).thenAnswer((_) async => false);

      final result = await dataSource.getCharacters(tFilter);

      verify(mockHttpService.get(tUrl)).called(1);
      expect(result.count, tResponseJson['count']);
      expect(result.characters.length, tCharacterModels.length);
      expect(result.characters[0].id, tCharacterModels[0].id);
      expect(result.characters[0].isFavorite, tCharacterModels[0].isFavorite);
    });

    test('debe lanzar una excepción si la solicitud falla', () async {
      when(mockHttpService.get(tUrl)).thenThrow(Exception('Error al obtener datos'));

      expect(
            () => dataSource.getCharacters(tFilter),
        throwsA(isA<Exception>()),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';

import 'character_model_test.mocks.dart';

@GenerateMocks([CharacterLocalDataSourceBase])
void main() {
  late MockCharacterLocalDataSourceBase mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCharacterLocalDataSourceBase();
  });

  group('CharacterModel', () {
    group('fromJson', () {
      final tJson = {
        'url': 'https://swapi.dev/api/people/1/',
        'name': 'Luke Skywalker',
      };

      test('debe retornar una instancia de CharacterModel con isFavorite true', () async {
        when(mockLocalDataSource.isCharacterSaved(1)).thenAnswer((_) async => true);

        final result = await CharacterModel.fromJson(tJson, mockLocalDataSource);

        expect(result.id, 1);
        expect(result.name, 'Luke Skywalker');
        expect(result.isFavorite, true);
        verify(mockLocalDataSource.isCharacterSaved(1)).called(1);
      });

      test('debe retornar una instancia de CharacterModel con isFavorite false', () async {
        when(mockLocalDataSource.isCharacterSaved(1)).thenAnswer((_) async => false);

        final result = await CharacterModel.fromJson(tJson, mockLocalDataSource);

        expect(result.id, 1);
        expect(result.name, 'Luke Skywalker');
        expect(result.isFavorite, false);
        verify(mockLocalDataSource.isCharacterSaved(1)).called(1);
      });

      test('debe manejar datos faltantes en el JSON', () async {
        final incompleteJson = {
          'url': 'https://swapi.dev/api/people/2/',
        };

        when(mockLocalDataSource.isCharacterSaved(2)).thenAnswer((_) async => false);

        final result = await CharacterModel.fromJson(incompleteJson, mockLocalDataSource);

        expect(result.id, 2);
        expect(result.name, 'Unknown');
        expect(result.isFavorite, false);
        verify(mockLocalDataSource.isCharacterSaved(2)).called(1);
      });
    });

    group('fromLocalJson', () {
      final tJson = {
        'id': 3,
        'name': 'Leia Organa',
      };

      test('debe retornar una instancia de CharacterModel desde JSON local', () async {
        final result = await CharacterModel.fromLocalJson(tJson);

        expect(result.id, 3);
        expect(result.name, 'Leia Organa');
        expect(result.isFavorite, true);
      });

      test('debe manejar datos faltantes en el JSON local', () async {
        final Map<String, dynamic> incompleteJson = {};

        final result = await CharacterModel.fromLocalJson(incompleteJson);

        expect(result.id, 0);
        expect(result.name, 'Unknown');
        expect(result.isFavorite, true);
      });
    });

    group('toJson', () {
      final tCharacterModel = CharacterModel(
        id: 1,
        name: 'Luke Skywalker',
        isFavorite: true,
      );

      test('debe convertir un CharacterModel a JSON', () {
        final result = tCharacterModel.toJson();

        expect(result, {
          'id': 1,
          'name': 'Luke Skywalker',
        });
      });
    });
  });
}

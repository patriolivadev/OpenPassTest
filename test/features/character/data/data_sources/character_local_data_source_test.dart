import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockPrefs;
  late CharacterLocalDataSource localDataSource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    localDataSource = CharacterLocalDataSource(prefs: mockPrefs);
  });

  group('saveCharacter', () {
    final tCharacter = CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true);
    final tCharacterJson = jsonEncode(tCharacter.toJson());

    test('debe guardar un Character en SharedPreferences', () async {
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      await localDataSource.saveCharacter(tCharacter);

      verify(mockPrefs.setString('character_1', tCharacterJson)).called(1);
    });
  });

  group('removeCharacter', () {
    test('debe eliminar un Character de SharedPreferences', () async {
      when(mockPrefs.remove(any)).thenAnswer((_) async => true);

      await localDataSource.removeCharacter(1);

      verify(mockPrefs.remove('character_1')).called(1);
    });
  });

  group('isCharacterSaved', () {
    test('debe retornar true si el Character está guardado', () async {
      when(mockPrefs.getString('character_1')).thenReturn('{}');

      final result = await localDataSource.isCharacterSaved(1);

      expect(result, true);
    });

    test('debe retornar false si el Character no está guardado', () async {
      when(mockPrefs.getString('character_1')).thenReturn(null);

      final result = await localDataSource.isCharacterSaved(1);

      expect(result, false);
    });
  });

  group('getAllCharacters', () {
    test('debe retornar una lista de Characters desde SharedPreferences', () async {
      final tCharacterJson = jsonEncode({'id': 1, 'name': 'Luke Skywalker', 'isFavorite': true});

      when(mockPrefs.getKeys()).thenReturn({'character_1'});
      when(mockPrefs.getString('character_1')).thenReturn(tCharacterJson);

      final result = await localDataSource.getAllCharacters();

      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.name, 'Luke Skywalker');
      expect(result.first.isFavorite, true);
    });


    test('debe retornar una lista vacía si no hay Characters guardados', () async {
      when(mockPrefs.getKeys()).thenReturn({});

      final result = await localDataSource.getAllCharacters();

      expect(result, isEmpty);
    });
  });
}

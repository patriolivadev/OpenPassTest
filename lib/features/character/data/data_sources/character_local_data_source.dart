import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CharacterLocalDataSourceBase {
  Future<void> saveCharacter(Character character);

  Future<void> removeCharacter(int characterId);

  Future<bool> isCharacterSaved(int characterId);

  Future<List<Character>> getAllCharacters();
}

@Injectable(as: CharacterLocalDataSourceBase)
class CharacterLocalDataSource extends CharacterLocalDataSourceBase {
  final SharedPreferences prefs;

  CharacterLocalDataSource({required this.prefs});

  @override
  Future<List<Character>> getAllCharacters() async {
    List<Character> characters = [];

    for (String key in prefs.getKeys()) {
      if (key.startsWith('character_')) {
        String? characterJson = prefs.getString(key);
        if (characterJson != null) {
          Map<String, dynamic> characterMap = jsonDecode(characterJson);

          characters.add(await CharacterModel.fromLocalJson(characterMap));
        }
      }
    }

    return characters;
  }



  @override
  Future<bool> isCharacterSaved(int characterId) async {
    String? characterJson = prefs.getString('character_$characterId');
    return characterJson != null;
  }

  @override
  Future<void> removeCharacter(int characterId) async {
    await prefs.remove('character_$characterId');
  }

  @override
  Future<void> saveCharacter(Character character) async {
    String characterJson = jsonEncode(character.toJson());
    await prefs.setString('character_${character.id}', characterJson);
  }
}

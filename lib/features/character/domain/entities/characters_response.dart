import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';

class CharactersResponse {
  List<Character> characters;
  int count;

  CharactersResponse({
    required this.characters,
    required this.count,
  });
}

import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required super.id,
    required super.name,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    String url = json['url'] ?? 'Unknown';

    final id = int.tryParse(url.split('/')[url.split('/').length - 2]) ?? 0;

    return CharacterModel(
      id: id,
      name: json['name'] ?? 'Unknown',
    );
  }

}

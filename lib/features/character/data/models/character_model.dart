import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required super.id,
    required super.name,
    required super.isFavorite,
  });

  static Future<CharacterModel> fromJson(
    Map<String, dynamic> json,
    CharacterLocalDataSourceBase localDataSource,
    bool isFromLocal,
  ) async {
    String url = json['url'] ?? 'Unknown';

    final id = int.tryParse(url.split('/')[url.split('/').length - 2]) ?? 0;

    final isFavorite = await localDataSource.isCharacterSaved(id);

    return CharacterModel(
      id: id,
      name: json['name'] ?? 'Unknown',
      isFavorite: isFromLocal ? true : isFavorite,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

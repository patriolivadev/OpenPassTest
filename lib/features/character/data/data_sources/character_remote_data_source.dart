import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/services/http_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';

abstract class CharacterRemoteDataSourceBase {
  final HttpServiceBase http;

  CharacterRemoteDataSourceBase({
    required this.http,
  });

  Future<CharactersResponse> getCharacters(Filter filter);
}

@Injectable(as: CharacterRemoteDataSourceBase)
class CharacterRemoteDataSource extends CharacterRemoteDataSourceBase {
  CharacterRemoteDataSource({
    required super.http,
  });

  @override
  Future<CharactersResponse> getCharacters(Filter filter) async {
    String url = 'https://swapi.dev/api/people/?search=${filter.name}&page=${filter.index}';

    final result = await http.get(url);

    List<CharacterModel> characters = (result['results'] as List)
        .map((characterJson) => CharacterModel.fromJson(Map<String, dynamic>.from(characterJson)))
        .toList();

    int count = result['count'];

    final CharactersResponse response = CharactersResponse(characters: characters, count: count);

    return response;
  }
}

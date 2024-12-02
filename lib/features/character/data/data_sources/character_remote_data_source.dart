import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/services/http_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';

abstract class CharacterRemoteDataSourceBase {
  final HttpServiceBase http;
  final CharacterLocalDataSourceBase local;

  CharacterRemoteDataSourceBase({
    required this.http,
    required this.local,
  });

  Future<CharactersResponse> getCharacters(Filter filter);
}

@Injectable(as: CharacterRemoteDataSourceBase)
class CharacterRemoteDataSource extends CharacterRemoteDataSourceBase {
  CharacterRemoteDataSource({
    required super.http,
    required super.local,
  });

  @override
  Future<CharactersResponse> getCharacters(Filter filter) async {
    String url = 'https://swapi.dev/api/people/?search=${filter.name}&page=${filter.index}';

    final result = await http.get(url);

    List<CharacterModel> characters = await Future.wait(
      (result['results'] as List).map(
            (characterJson) async {
          return await CharacterModel.fromJson(
            Map<String, dynamic>.from(characterJson),
            local
          );
        },
      ),
    );

    int count = result['count'];

    final CharactersResponse response = CharactersResponse(characters: characters, count: count);

    return response;
  }

}

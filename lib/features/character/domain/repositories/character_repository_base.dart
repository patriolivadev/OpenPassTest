import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_remote_data_source.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';

abstract class CharacterRepositoryBase {
  final CharacterRemoteDataSourceBase remote;
  final CharacterLocalDataSourceBase local;

  CharacterRepositoryBase({
    required this.remote,
    required this.local
  });

  Future<Either<Failure, CharactersResponse>> getCharacters(Filter filter);
  Future<Either<Failure, List<Character>>> getFavoriteCharacters();
  Future<Either<Failure, int>> saveFavoriteCharacter(Character character);
  Future<Either<Failure, int>> removeCharacterIntent(int id);
}
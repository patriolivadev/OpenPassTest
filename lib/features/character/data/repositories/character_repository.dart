import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';

@Injectable(as: CharacterRepositoryBase)
class CharacterRepository extends CharacterRepositoryBase {
  CharacterRepository({
    required super.remote,
    required super.local,
  });

  @override
  Future<Either<Failure, CharactersResponse>> getCharacters(
      Filter filter) async {
    try {
      CharactersResponse response = await remote.getCharacters(filter);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getFavoriteCharacters() async {
    try {
      List<Character> response = await local.getAllCharacters();
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, int>> saveFavoriteCharacter(Character character) async {
    try {
      await local.saveCharacter(character);
      return Right(character.id);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, int>> removeCharacterIntent(int id) async {
    try {
      await local.removeCharacter(id);
      return Right(id);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure(message: '$e'));
    }
  }
}

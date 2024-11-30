import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';

@injectable
class GetFavoriteCharactersUseCase
    extends UseCaseBase<List<Character>, NoParams> {
  final CharacterRepositoryBase repository;

  GetFavoriteCharactersUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<Character>>> call(params) {
    return repository.getFavoriteCharacters();
  }
}

import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';

@injectable
class SaveFavoriteCharacterUseCase extends UseCaseBase<int, Character> {
  final CharacterRepositoryBase repository;

  SaveFavoriteCharacterUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, int>> call(params) {
    return repository.saveFavoriteCharacter(params);
  }
}

import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';

@injectable
class GetCharactersUseCase extends UseCaseBase<CharactersResponse, Filter> {
  final CharacterRepositoryBase repository;

  GetCharactersUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, CharactersResponse>> call(params) {
    return repository.getCharacters(params);
  }
}

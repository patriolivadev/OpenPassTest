import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_favorite_characters_use_case.dart';

import 'get_favorite_characters_use_case_test.mocks.dart';

@GenerateMocks([CharacterRepositoryBase])
void main() {
  late MockCharacterRepositoryBase mockRepository;
  late GetFavoriteCharactersUseCase useCase;

  setUp(() {
    mockRepository = MockCharacterRepositoryBase();
    useCase = GetFavoriteCharactersUseCase(repository: mockRepository);
  });

  group('GetFavoriteCharactersUseCase', () {
    final tCharacters = [
      CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true),
      CharacterModel(id: 2, name: 'Leia Organa', isFavorite: true),
    ];

    test('debe delegar la llamada al repositorio y retornar una lista de favoritos', () async {
      when(mockRepository.getFavoriteCharacters())
          .thenAnswer((_) async => Right(tCharacters));

      final result = await useCase.call(NoParams());

      verify(mockRepository.getFavoriteCharacters()).called(1);
      expect(result, Right(tCharacters));
    });

    test('debe retornar un Failure si el repositorio lanza un error', () async {
      final tFailure = UnhandledFailure(message: 'Error del repositorio');
      when(mockRepository.getFavoriteCharacters())
          .thenAnswer((_) async => Left(tFailure));

      final result = await useCase.call(NoParams());

      verify(mockRepository.getFavoriteCharacters()).called(1);
      expect(result, Left(tFailure));
    });
  });
}

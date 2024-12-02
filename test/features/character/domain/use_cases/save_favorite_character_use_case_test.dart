import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/save_favorite_character_use_case.dart';

import 'save_favorite_character_use_case_test.mocks.dart';

@GenerateMocks([CharacterRepositoryBase])
void main() {
  late MockCharacterRepositoryBase mockRepository;
  late SaveFavoriteCharacterUseCase useCase;

  setUp(() {
    mockRepository = MockCharacterRepositoryBase();
    useCase = SaveFavoriteCharacterUseCase(repository: mockRepository);
  });

  group('SaveFavoriteCharacterUseCase', () {
    final tCharacter = CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true);

    test('debe delegar la llamada al repositorio y retornar el id del personaje', () async {
      when(mockRepository.saveFavoriteCharacter(tCharacter))
          .thenAnswer((_) async => Right(tCharacter.id));

      final result = await useCase.call(tCharacter);

      verify(mockRepository.saveFavoriteCharacter(tCharacter)).called(1);
      expect(result, Right(tCharacter.id));
    });

    test('debe retornar un Failure si el repositorio lanza un error', () async {
      final tFailure = UnhandledFailure(message: 'Error del repositorio');
      when(mockRepository.saveFavoriteCharacter(tCharacter))
          .thenAnswer((_) async => Left(tFailure));

      final result = await useCase.call(tCharacter);

      verify(mockRepository.saveFavoriteCharacter(tCharacter)).called(1);
      expect(result, Left(tFailure));
    });
  });
}

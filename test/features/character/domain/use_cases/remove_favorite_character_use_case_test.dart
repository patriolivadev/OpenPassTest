import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/remove_favorite_character_use_case.dart';

import 'remove_favorite_character_use_case_test.mocks.dart';

@GenerateMocks([CharacterRepositoryBase])
void main() {
  late MockCharacterRepositoryBase mockRepository;
  late RemoveFavoriteCharacterUseCase useCase;

  setUp(() {
    mockRepository = MockCharacterRepositoryBase();
    useCase = RemoveFavoriteCharacterUseCase(repository: mockRepository);
  });

  group('RemoveFavoriteCharacterUseCase', () {
    const tCharacterId = 1;

    test('debe delegar la llamada al repositorio y retornar el id del personaje', () async {
      when(mockRepository.removeCharacterIntent(tCharacterId))
          .thenAnswer((_) async => const Right(tCharacterId));

      final result = await useCase.call(tCharacterId);

      verify(mockRepository.removeCharacterIntent(tCharacterId)).called(1);
      expect(result, const Right(tCharacterId));
    });

    test('debe retornar un Failure si el repositorio lanza un error', () async {
      final tFailure = UnhandledFailure(message: 'Error del repositorio');
      when(mockRepository.removeCharacterIntent(tCharacterId))
          .thenAnswer((_) async => Left(tFailure));

      final result = await useCase.call(tCharacterId);

      verify(mockRepository.removeCharacterIntent(tCharacterId)).called(1);
      expect(result, Left(tFailure));
    });
  });
}

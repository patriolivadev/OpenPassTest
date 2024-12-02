import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_characters_use_case.dart';

import 'get_characters_use_case_test.mocks.dart';

@GenerateMocks([CharacterRepositoryBase])
void main() {
  late MockCharacterRepositoryBase mockRepository;
  late GetCharactersUseCase useCase;

  setUp(() {
    mockRepository = MockCharacterRepositoryBase();
    useCase = GetCharactersUseCase(repository: mockRepository);
  });

  group('GetCharactersUseCase', () {
    final tFilter = Filter(name: 'Luke', index: 1);
    final tCharactersResponse = CharactersResponse(
      characters: [],
      count: 0,
    );

    test('debe delegar la llamada al repositorio y retornar un CharactersResponse', () async {
      when(mockRepository.getCharacters(tFilter))
          .thenAnswer((_) async => Right(tCharactersResponse));

      final result = await useCase.call(tFilter);

      verify(mockRepository.getCharacters(tFilter)).called(1);
      expect(result, Right(tCharactersResponse));
    });

    test('debe retornar un Failure si el repositorio lanza un error', () async {
      final tFailure = UnhandledFailure(message: 'Error del repositorio');
      when(mockRepository.getCharacters(tFilter)).thenAnswer((_) async => Left(tFailure));

      final result = await useCase.call(tFilter);

      verify(mockRepository.getCharacters(tFilter)).called(1);
      expect(result, Left(tFailure));
    });
  });
}

import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_local_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_remote_data_source.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/repositories/character_repository.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';

import 'character_repository_test.mocks.dart';

@GenerateMocks([CharacterRemoteDataSourceBase, CharacterLocalDataSourceBase])
void main() {
  late MockCharacterRemoteDataSourceBase mockRemoteDataSource;
  late MockCharacterLocalDataSourceBase mockLocalDataSource;
  late CharacterRepository repository;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSourceBase();
    mockLocalDataSource = MockCharacterLocalDataSourceBase();
    repository = CharacterRepository(remote: mockRemoteDataSource, local: mockLocalDataSource);
  });

  group('getCharacters', () {
    final tFilter = Filter(name: 'Luke', index: 1);
    final tCharactersResponse = CharactersResponse(
      characters: [
        CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true),
        CharacterModel(id: 2, name: 'Leia Organa', isFavorite: false),
      ],
      count: 2,
    );

    test('debe retornar CharactersResponse si la llamada al remoto es exitosa', () async {
      when(mockRemoteDataSource.getCharacters(tFilter)).thenAnswer((_) async => tCharactersResponse);

      final result = await repository.getCharacters(tFilter);

      verify(mockRemoteDataSource.getCharacters(tFilter)).called(1);
      expect(result, Right(tCharactersResponse));
    });

    test('debe retornar un Failure si ocurre una excepción', () async {
      when(mockRemoteDataSource.getCharacters(tFilter)).thenThrow(UnhandledFailure(message: 'Error remoto'));

      final result = await repository.getCharacters(tFilter);

      verify(mockRemoteDataSource.getCharacters(tFilter)).called(1);
      expect(result.fold((failure) => failure, (_) => null), isA<UnhandledFailure>());
    });
  });

  group('getFavoriteCharacters', () {
    final tFavoriteCharacters = [
      CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true),
      CharacterModel(id: 2, name: 'Leia Organa', isFavorite: true),
    ];

    test('debe retornar la lista de favoritos si la llamada al local es exitosa', () async {
      when(mockLocalDataSource.getAllCharacters()).thenAnswer((_) async => tFavoriteCharacters);

      final result = await repository.getFavoriteCharacters();

      verify(mockLocalDataSource.getAllCharacters()).called(1);
      expect(result, Right(tFavoriteCharacters));
    });

    test('debe retornar un Failure si ocurre una excepción', () async {
      when(mockLocalDataSource.getAllCharacters()).thenThrow(UnhandledFailure(message: 'Error local'));

      final result = await repository.getFavoriteCharacters();

      verify(mockLocalDataSource.getAllCharacters()).called(1);
      expect(result.fold((failure) => failure, (_) => null), isA<UnhandledFailure>());
    });
  });

  group('saveFavoriteCharacter', () {
    final tCharacter = CharacterModel(id: 1, name: 'Luke Skywalker', isFavorite: true);

    test('debe retornar el id del personaje si la operación es exitosa', () async {
      when(mockLocalDataSource.saveCharacter(tCharacter)).thenAnswer((_) async {});

      final result = await repository.saveFavoriteCharacter(tCharacter);

      verify(mockLocalDataSource.saveCharacter(tCharacter)).called(1);
      expect(result, Right(tCharacter.id));
    });

    test('debe retornar un Failure si ocurre una excepción', () async {
      when(mockLocalDataSource.saveCharacter(tCharacter)).thenThrow(UnhandledFailure(message: 'Error local'));

      final result = await repository.saveFavoriteCharacter(tCharacter);

      verify(mockLocalDataSource.saveCharacter(tCharacter)).called(1);
      expect(result.fold((failure) => failure, (_) => null), isA<UnhandledFailure>());
    });
  });

  group('removeCharacterIntent', () {
    const tId = 1;

    test('debe retornar el id del personaje si la operación es exitosa', () async {
      when(mockLocalDataSource.removeCharacter(tId)).thenAnswer((_) async {});

      final result = await repository.removeCharacterIntent(tId);

      verify(mockLocalDataSource.removeCharacter(tId)).called(1);
      expect(result, const Right(tId));
    });

    test('debe retornar un Failure si ocurre una excepción', () async {
      when(mockLocalDataSource.removeCharacter(tId)).thenThrow(UnhandledFailure(message: 'Error local'));

      final result = await repository.removeCharacterIntent(tId);

      verify(mockLocalDataSource.removeCharacter(tId)).called(1);
      expect(result.fold((failure) => failure, (_) => null), isA<UnhandledFailure>());
    });
  });
}

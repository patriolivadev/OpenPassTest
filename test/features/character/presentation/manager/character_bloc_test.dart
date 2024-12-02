import 'package:core_encode/core_encode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/models/character_model.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_characters_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_favorite_characters_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/remove_favorite_character_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/save_favorite_character_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart';

import 'character_bloc_test.mocks.dart';

@GenerateMocks([
  GetCharactersUseCase,
  GetFavoriteCharactersUseCase,
  SaveFavoriteCharacterUseCase,
  RemoveFavoriteCharacterUseCase,
])

void main() {
  late MockGetCharactersUseCase mockGetCharactersUseCase;
  late MockGetFavoriteCharactersUseCase mockGetFavoriteCharactersUseCase;
  late MockSaveFavoriteCharacterUseCase mockSaveFavoriteCharacterUseCase;
  late MockRemoveFavoriteCharacterUseCase mockRemoveFavoriteCharacterUseCase;
  late CharacterBloc bloc;

  setUp(() {
    mockGetCharactersUseCase = MockGetCharactersUseCase();
    mockGetFavoriteCharactersUseCase = MockGetFavoriteCharactersUseCase();
    mockSaveFavoriteCharacterUseCase = MockSaveFavoriteCharacterUseCase();
    mockRemoveFavoriteCharacterUseCase = MockRemoveFavoriteCharacterUseCase();

    bloc = CharacterBloc(
      getCharactersUseCase: mockGetCharactersUseCase,
      getFavoriteCharactersUseCase: mockGetFavoriteCharactersUseCase,
      saveFavoriteCharacterUseCase: mockSaveFavoriteCharacterUseCase,
      removeFavoriteCharacterUseCase: mockRemoveFavoriteCharacterUseCase,
    );
  });

  group('CharacterBloc Tests', () {
    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnGetCharacters] cuando ActionGetCharacters es exitoso',
      build: () {
        when(mockGetCharactersUseCase(any)).thenAnswer(
              (_) async => Right(CharactersResponse(characters: [], count: 0)),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionGetCharacters(filter: Filter(name: '', index: 1))),
      expect: () => [
        isA<OnLoading>(),
        isA<OnGetCharacters>().having((state) => state.response.count, 'count', 0),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnGetCharactersFailure] cuando ActionGetCharacters falla',
      build: () {
        when(mockGetCharactersUseCase(any)).thenAnswer(
              (_) async => Left(UnhandledFailure(message: 'Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionGetCharacters(filter: Filter(name: '', index: 1))),
      expect: () => [
        isA<OnLoading>(),
        isA<OnGetCharactersFailure>().having((state) => state.failure.message, 'message', 'Error'),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnGetFavoriteCharacters] cuando ActionGetFavoriteCharacters es exitoso',
      build: () {
        when(mockGetFavoriteCharactersUseCase(any)).thenAnswer(
              (_) async => Right([CharacterModel(id: 1, name: 'Character 1', isFavorite: true)]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionGetFavoriteCharacters()),
      expect: () => [
        isA<OnLoading>(),
        isA<OnGetFavoriteCharacters>().having(
              (state) => state.characters.length,
          'length',
          1,
        ),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnSaveFavoriteCharacter] cuando ActionSaveFavoriteCharacter es exitoso',
      build: () {
        when(mockSaveFavoriteCharacterUseCase(any)).thenAnswer(
              (_) async => const Right(1),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionSaveFavoriteCharacter(
        character: CharacterModel(id: 1, name: 'Character 1', isFavorite: true),
      )),
      expect: () => [
        isA<OnLoading>(),
        isA<OnSaveFavoriteCharacter>().having((state) => state.id, 'id', 1),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnSaveFavoriteCharacterFailure] cuando ActionSaveFavoriteCharacter falla',
      build: () {
        when(mockSaveFavoriteCharacterUseCase(any)).thenAnswer(
              (_) async => Left(UnhandledFailure(message: 'Error saving character')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionSaveFavoriteCharacter(
        character: CharacterModel(id: 1, name: 'Character 1', isFavorite: true),
      )),
      expect: () => [
        isA<OnLoading>(),
        isA<OnSaveFavoriteCharacterFailure>().having(
              (state) => state.failure.message,
          'message',
          'Error saving character',
        ),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnRemoveFavoriteCharacter] cuando ActionRemoveFavoriteCharacter es exitoso',
      build: () {
        when(mockRemoveFavoriteCharacterUseCase(any)).thenAnswer(
              (_) async => const Right(1),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionRemoveFavoriteCharacter(id: 1)),
      expect: () => [
        isA<OnLoading>(),
        isA<OnRemoveFavoriteCharacter>().having((state) => state.id, 'id', 1),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'Emite [OnLoading, OnRemoveFavoriteCharacterFailure] cuando ActionRemoveFavoriteCharacter falla',
      build: () {
        when(mockRemoveFavoriteCharacterUseCase(any)).thenAnswer(
              (_) async => Left(UnhandledFailure(message: 'Error removing character')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ActionRemoveFavoriteCharacter(id: 1)),
      expect: () => [
        isA<OnLoading>(),
        isA<OnRemoveFavoriteCharacterFailure>().having(
              (state) => state.failure.message,
          'message',
          'Error removing character',
        ),
      ],
    );
  });
}

import 'dart:async';

import 'package:core_encode/core_encode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_characters_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_favorite_characters_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/remove_favorite_character_use_case.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/save_favorite_character_use_case.dart';

part 'character_event.dart';

part 'character_state.dart';

@lazySingleton
@injectable
class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharactersUseCase getCharactersUseCase;
  final GetFavoriteCharactersUseCase getFavoriteCharactersUseCase;
  final SaveFavoriteCharacterUseCase saveFavoriteCharacterUseCase;
  final RemoveFavoriteCharacterUseCase removeFavoriteCharacterUseCase;

  CharacterBloc({
    required this.getCharactersUseCase,
    required this.getFavoriteCharactersUseCase,
    required this.saveFavoriteCharacterUseCase,
    required this.removeFavoriteCharacterUseCase,
  }) : super(CharacterInitial()) {
    on<ActionGetCharacters>(_getCharacters);
    on<ActionGetFavoriteCharacters>(_getFavoriteCharacters);
    on<ActionSaveFavoriteCharacter>(_saveCharacter);
    on<ActionRemoveFavoriteCharacter>(_removeCharacter);
  }

  FutureOr<void> _getCharacters(
      ActionGetCharacters event,
      Emitter<CharacterState> emit,
      ) async {
    emit(OnLoading());

    final result = await getCharactersUseCase(event.filter);

    result.fold(
          (l) => emit(OnGetCharactersFailure(failure: l)),
          (r) => emit(OnGetCharacters(response: r)),
    );
  }

  FutureOr<void> _getFavoriteCharacters(
      ActionGetFavoriteCharacters event,
      Emitter<CharacterState> emit,
      ) async {
    emit(OnLoading());

    final result = await getFavoriteCharactersUseCase(NoParams());

    result.fold(
          (l) => emit(OnGetCharactersFailure(failure: l)),
          (r) => emit(OnGetFavoriteCharacters(characters: r)),
    );
  }

  FutureOr<void> _saveCharacter(
      ActionSaveFavoriteCharacter event,
      Emitter<CharacterState> emit,
      ) async {
    emit(OnLoading());

    final result = await saveFavoriteCharacterUseCase(event.character);

    result.fold(
          (l) => emit(OnSaveFavoriteCharacterFailure(failure: l)),
          (r) => emit(OnSaveFavoriteCharacter(id: r)),
    );
  }

  FutureOr<void> _removeCharacter(
      ActionRemoveFavoriteCharacter event,
      Emitter<CharacterState> emit,
      ) async {
    emit(OnLoading());

    final result = await removeFavoriteCharacterUseCase(event.id);

    result.fold(
          (l) => emit(OnRemoveFavoriteCharacterFailure(failure: l)),
          (r) => emit(OnRemoveFavoriteCharacter(id: r)),
    );
  }
}

import 'dart:async';

import 'package:core_encode/core_encode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_characters_use_case.dart';

part 'character_event.dart';

part 'character_state.dart';

@injectable
class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharactersUseCase getCharactersUseCase;

  CharacterBloc({
    required this.getCharactersUseCase,
  }) : super(CharacterInitial()) {
    on<ActionGetCharacters>(_getCharacters);
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
}

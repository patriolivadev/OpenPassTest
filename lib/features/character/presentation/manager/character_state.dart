part of 'character_bloc.dart';

@immutable
sealed class CharacterState {}

final class CharacterInitial extends CharacterState {}

final class OnLoading extends CharacterState {}

final class OnGetCharacters extends CharacterState {
  final CharactersResponse response;

  OnGetCharacters({
    required this.response,
  });
}

final class OnGetCharactersFailure extends CharacterState {
  final Failure failure;

  OnGetCharactersFailure({
    required this.failure,
  });
}

final class OnGetFavoriteCharacters extends CharacterState {
  final List<Character> characters;

  OnGetFavoriteCharacters({
    required this.characters,
  });
}

final class OnSaveFavoriteCharacter extends CharacterState {
  final int id;

  OnSaveFavoriteCharacter({required this.id});
}

final class OnSaveFavoriteCharacterFailure extends CharacterState {
  final Failure failure;

  OnSaveFavoriteCharacterFailure({
    required this.failure,
  });
}

final class OnRemoveFavoriteCharacter extends CharacterState {
  final int id;

  OnRemoveFavoriteCharacter({required this.id});
}

final class OnRemoveFavoriteCharacterFailure extends CharacterState {
  final Failure failure;

  OnRemoveFavoriteCharacterFailure({
    required this.failure,
  });
}

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

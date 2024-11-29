part of 'character_bloc.dart';

@immutable
sealed class CharacterEvent {}

final class ActionGetCharacters extends CharacterEvent {
  final Filter filter;

  ActionGetCharacters({required this.filter});
}

final class ActionSaveFavoriteCharacter extends CharacterEvent {
  final Character character;

  ActionSaveFavoriteCharacter({required this.character});
}

final class ActionRemoveFavoriteCharacter extends CharacterEvent {
  final int id;

  ActionRemoveFavoriteCharacter({required this.id});
}

final class ActionGetFavoriteCharacters extends CharacterEvent {}

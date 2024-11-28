part of 'character_bloc.dart';

@immutable
sealed class CharacterEvent {}

final class ActionGetCharacters extends CharacterEvent {
  final Filter filter;

  ActionGetCharacters({required this.filter});
}

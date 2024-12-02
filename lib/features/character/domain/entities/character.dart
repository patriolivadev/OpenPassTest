import 'package:core_encode/core_encode.dart';

abstract class Character extends Entity {
  final int id;
  final String name;
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.isFavorite,
  });
}

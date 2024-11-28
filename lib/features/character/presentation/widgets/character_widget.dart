import 'package:flutter/material.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';

class CharacterWidget extends StatefulWidget {
  final Character character;

  const CharacterWidget({
    super.key,
    required this.character,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  List<int> favorites = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.network(
            getCharacterImageUrl(widget.character.id),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 50),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.character.name),
        ),
        IconButton(
          icon: Icon(
            favorites.contains(widget.character.id)
                ? Icons.star
                : Icons.star_border,
            color: favorites.contains(widget.character.id) ? Colors.yellow : null,
          ),
          onPressed: () => toggleFavorite(widget.character.id),
        ),
      ],
    );
  }

  String getCharacterImageUrl(int id) {
    return 'https://starwars-visualguide.com/assets/img/characters/$id.jpg';
  }

  void toggleFavorite(int id) {
    setState(() {
      favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    });
  }
}

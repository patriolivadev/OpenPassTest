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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.character.name,
                      style: const TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    favorites.contains(widget.character.id)
                        ? Icons.star
                        : Icons.star_border,
                    color: favorites.contains(widget.character.id)
                        ? Colors.yellow
                        : null,
                    size: 40,
                  ),
                  onPressed: () => toggleFavorite(widget.character.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                getCharacterImageUrl(widget.character.id),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }


  String getCharacterImageUrl(int id) {
    String url =
        'https://starwars-visualguide.com/assets/img/characters/$id.jpg';
    print(url);
    return url;
  }

  void toggleFavorite(int id) {
    setState(() {
      favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    });
  }
}

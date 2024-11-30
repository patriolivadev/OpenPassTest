import 'package:flutter/material.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/character.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart';

class CharacterWidget extends StatelessWidget {
  final Character character;

  const CharacterWidget({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final CharacterBloc bloc = getIt<CharacterBloc>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context, bloc),
          const SizedBox(height: 8),
          _buildCharacterImage(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CharacterBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                character.name,
                style: const TextStyle(fontSize: 25),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              character.isFavorite ? Icons.star : Icons.star_border,
              color: character.isFavorite ? Colors.yellow : null,
              size: 40,
            ),
            onPressed: () => _toggleFavorite(bloc),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          _getCharacterImageUrl(),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 50),
        ),
      ),
    );
  }

  String _getCharacterImageUrl() {
    return 'https://starwars-visualguide.com/assets/img/characters/${character.id}.jpg';
  }

  void _toggleFavorite(CharacterBloc bloc) {
    if (character.isFavorite) {
      bloc.add(ActionRemoveFavoriteCharacter(id: character.id));
    } else {
      bloc.add(ActionSaveFavoriteCharacter(character: character));
    }
  }
}

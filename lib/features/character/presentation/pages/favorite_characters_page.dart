import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/widgets/character_widget.dart';

class FavoriteCharactersPage extends StatefulWidget {
  const FavoriteCharactersPage({super.key});

  @override
  State<FavoriteCharactersPage> createState() => _FavoriteCharactersPageState();
}

class _FavoriteCharactersPageState extends State<FavoriteCharactersPage> {
  final CharacterBloc _bloc = getIt<CharacterBloc>();
  final List characters = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCharacters();
  }

  void _fetchFavoriteCharacters() {
    _bloc.add(ActionGetFavoriteCharacters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<CharacterBloc, CharacterState>(
          bloc: _bloc,
          builder: builder,
          listener: listener,
        ),
      ),
    );
  }

  void listener(BuildContext context, CharacterState state) {
    if (state is OnGetFavoriteCharacters) {
      characters
        ..clear()
        ..addAll(state.characters);
      setState(() {});
    } else if (state is OnSaveFavoriteCharacter) {
      _updateFavoriteStatus(state.id, true);
    } else if (state is OnRemoveFavoriteCharacter) {
      _removeCharacter(state.id);
    }
  }

  void _updateFavoriteStatus(int id, bool isFavorite) {
    for (final character in characters) {
      if (character.id == id) {
        character.isFavorite = isFavorite;
      }
    }
    setState(() {});
  }

  void _removeCharacter(int id) {
    characters.removeWhere((character) => character.id == id);
    setState(() {});
  }

  Widget builder(BuildContext context, CharacterState state) {
    if (state is OnLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnGetCharactersFailure) {
      return const Center(
        child: Text(
          '¡Ups! Algo salió mal.',
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      );
    } else if (characters.isEmpty) {
      return const Center(
        child: Text(
          'Aún no hay favoritos guardados.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return _buildCharacterList();
  }

  Widget _buildCharacterList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.deepPurple.withOpacity(0.3),
          child: CharacterWidget(character: character),
        );
      },
    );
  }
}

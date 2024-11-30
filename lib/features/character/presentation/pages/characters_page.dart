import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/pages/favorite_characters_page.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/widgets/character_widget.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final CharacterBloc _bloc = getIt<CharacterBloc>();
  final TextEditingController _textController = TextEditingController();

  List characters = [];
  int count = 0;
  int pageIndex = 1;
  Filter filter = Filter(name: '', index: 1);
  String characterName = '';
  Timer? _debounce;
  late Size size;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _fetchCharacters() {
    _bloc.add(ActionGetCharacters(filter: filter));
  }

  void _updateCharacters(String name, int page) {
    setState(() {
      characterName = name;
      pageIndex = page;
      filter = Filter(name: characterName, index: pageIndex);
    });
    _fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: BlocConsumer<CharacterBloc, CharacterState>(
                bloc: _bloc,
                builder: builder,
                listener: listener,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void listener(BuildContext context, CharacterState state) {
    if (state is OnGetCharacters) {
      characters = state.response.characters;
      count = state.response.count;
    } else if (state is OnSaveFavoriteCharacter ||
        state is OnRemoveFavoriteCharacter) {
      _updateFavoriteStatus(state);
    }

    setState(() {});
  }

  void _updateFavoriteStatus(CharacterState state) {
    final isFavorite = state is OnSaveFavoriteCharacter;
    for (final element in characters) {
      if (element.id == (state as dynamic).id) {
        element.isFavorite = isFavorite;
      }
    }
  }

  Widget builder(BuildContext context, CharacterState state) {
    if (state is OnLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is OnGetCharactersFailure) {
      return const Center(child: Text('¡Ups! Algo salió mal.'));
    }
    if (count == 0) {
      return const Center(child: Text('No se encontraron resultados.'));
    }
    return Column(
      children: [
        Expanded(child: _buildCharacterList()),
        const SizedBox(height: 10),
        _buildPager(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        children: [
          _buildSearchField(),
          SizedBox(width: size.width * 0.04),
          _buildFavoritesButton(),
        ],
      ),
    );
  }

  Expanded _buildSearchField() {
    return Expanded(
      child: TextField(
        controller: _textController,
        decoration: const InputDecoration(hintText: 'Nombre del personaje...'),
        onChanged: (value) {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _updateCharacters(value, 1);
          });
        },
      ),
    );
  }

  ElevatedButton _buildFavoritesButton() {
    return ElevatedButton(
      onPressed: _navigateToFavorites,
      child: const Text('Show Favorites'),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoriteCharactersPage()),
    );
  }

  Row _buildPager() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: pageIndex > 1
              ? () => _updateCharacters(characterName, pageIndex - 1)
              : null,
        ),
        const SizedBox(width: 20),
        Text('Page $pageIndex'),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: count > pageIndex * 10
              ? () => _updateCharacters(characterName, pageIndex + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildCharacterList() {
    final itemCount = (pageIndex * 10 <= count) ? 10 : count % 10;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          child: CharacterWidget(character: character),
        );
      },
    );
  }
}

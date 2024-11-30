import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart';
import 'package:open_pass_test_oliva_patricio/core/themes.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Personajes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppThemes.backgroundColor,
      ),
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
      return const Center(
        child: Text(
          '¡Ups! Algo salió mal.',
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      );
    }
    if (count == 0) {
      return const Center(
        child: Text(
          'No se encontraron resultados.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
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
        decoration: InputDecoration(
          hintText: 'Buscar personaje...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemes.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: _navigateToFavorites,
      child: const Text(
        'Favoritos',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoriteCharactersPage()),
    );
  }

  Row _buildPager() {
    int totalPages = (count / 10).ceil();
    const int maxButtons = 5;

    int startPage = (pageIndex - (maxButtons ~/ 2)).clamp(1, totalPages);
    int endPage = (startPage + maxButtons - 1).clamp(1, totalPages);

    if (endPage - startPage < maxButtons - 1) {
      startPage = (endPage - maxButtons + 1).clamp(1, totalPages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        firstPageButton(),
        previousPageButton(),
        ...pagesButtonsRow(endPage, startPage),
        nextPageButton(totalPages),
        lastPageButton(totalPages),
      ],
    );
  }

  IconButton firstPageButton() {
    return IconButton(
      icon: const Icon(
        Icons.first_page,
        size: 30,
      ),
      color: pageIndex > 1 ? Colors.white : AppThemes.backgroundColor,
      onPressed:
          pageIndex > 1 ? () => _updateCharacters(characterName, 1) : null,
    );
  }

  IconButton previousPageButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      color: pageIndex > 1 ? Colors.white : AppThemes.backgroundColor,
      onPressed: pageIndex > 1
          ? () => _updateCharacters(characterName, pageIndex - 1)
          : null,
    );
  }

  List<Widget> pagesButtonsRow(int endPage, int startPage) {
    return List.generate(
      endPage - startPage + 1,
      (index) {
        int page = startPage + index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor:
                  page == pageIndex ? AppThemes.primary : AppThemes.backgroundColor,
              elevation: page == pageIndex ? 0 : 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: page != pageIndex
                ? () => _updateCharacters(characterName, page)
                : null,
            child: Text(
              '$page',
              style: TextStyle(
                color: page == pageIndex ? Colors.white : Colors.black,
                fontWeight:
                    page == pageIndex ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  IconButton nextPageButton(int totalPages) {
    return IconButton(
      icon: const Icon(Icons.arrow_forward_ios),
      color: pageIndex < totalPages ? Colors.white : AppThemes.backgroundColor,
      onPressed: pageIndex < totalPages
          ? () => _updateCharacters(characterName, pageIndex + 1)
          : null,
    );
  }

  IconButton lastPageButton(int totalPages) {
    return IconButton(
      icon: const Icon(
        Icons.last_page,
        size: 30,
      ),
      color: pageIndex < totalPages ? Colors.white : AppThemes.backgroundColor,
      onPressed: pageIndex < totalPages
          ? () => _updateCharacters(characterName, totalPages)
          : null,
    );
  }

  Widget _buildCharacterList() {
    final itemCount = (pageIndex * 10 <= count) ? 10 : count % 10;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          color: AppThemes.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: AppThemes.primary.withOpacity(0.3),
          child: CharacterWidget(character: character),
        );
      },
    );
  }
}

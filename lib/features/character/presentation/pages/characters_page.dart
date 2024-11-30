import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart';
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart';
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
  bool showOnlyFavorites = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _bloc.add(ActionGetCharacters(filter: filter));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: buildHeader(),
            ),
            const SizedBox(height: 16),
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

  void listener(context, state) {
    if (state is OnGetCharacters) {
      characters = state.response.characters;
      count = state.response.count;
    }

    if (state is OnSaveFavoriteCharacter) {
      for (var element in characters) {
        if (element.id == state.id) {
          element.isFavorite = true;
        }
      }
    }

    if (state is OnRemoveFavoriteCharacter){
      for (var element in characters) {
        if (element.id == state.id) {
          element.isFavorite = false;
        }
      }
    }

    setState(() {});
  }

  Widget builder(context, state) {
    if (state is OnLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is OnGetCharactersFailure) {
      return const Center(
        child: Text('¡Ups! Algo salió mal.'),
      );
    }

    if (count == 0) {
      return const Center(
        child: Text('No se encontraron resultados'),
      );
    }

    return Column(
      children: [
        Expanded(child: buildList()),
        const SizedBox(height: 10,),
        buildPager(),
      ],
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        buildSearchField(),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        buildFavoritesButton(),
      ],
    );
  }

  Expanded buildSearchField() {
    return Expanded(
      child: TextField(
        controller: _textController,
        decoration: const InputDecoration(hintText: 'Nombre del personaje...'),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            characterName = value;
            pageIndex = 1;
            filter = Filter(name: characterName, index: pageIndex);
            _bloc.add(ActionGetCharacters(filter: filter));
          });
        },
      ),
    );
  }

  ElevatedButton buildFavoritesButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showOnlyFavorites = !showOnlyFavorites;
        });
      },
      child: Text(showOnlyFavorites ? 'Show All' : 'Show Favorites'),
    );
  }

  Row buildPager() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: pageIndex > 1
              ? () {
            setState(() {
              pageIndex--;
            });
            filter = Filter(name: characterName, index: pageIndex);
            _bloc.add(ActionGetCharacters(filter: filter));
          }
              : null,
        ),
        const SizedBox(width: 20,),
        Text('Page $pageIndex'),
        const SizedBox(width: 20,),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: count > pageIndex * 10
              ? () {
            setState(() {
              pageIndex++;
            });
            filter = Filter(name: characterName, index: pageIndex);
            _bloc.add(ActionGetCharacters(filter: filter));
          }
              : null,
        ),
      ],
    );
  }

  Widget buildList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: (pageIndex * 10 <= count) ? 10 : count % 10,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          child: CharacterWidget(character: character),
        );
      },
    );
  }
}

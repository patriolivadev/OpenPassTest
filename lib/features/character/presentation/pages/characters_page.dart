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

  List characters = [];
  int count = 0;
  int pageIndex = 1;
  Filter filter = Filter(name: '', index: 1);
  String characterName = '';
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(ActionGetCharacters(filter: filter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        bloc: _bloc,
        builder: builder,
        listener: listener,
      ),
    );
  }

  void listener(context, state) {
    if (state is OnGetCharacters) {
      characters = state.response.characters;
      count = state.response.count;
      setState(() {});
    }
  }

  Widget builder(context, state) {
    if (state is OnLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is OnGetCharactersFailure){
      return const Center(
        child: Text('¡Ups! Algo salió mal.'),
      );
    }

    if (count == 0) {
      return const Center(
        child: Text('No se encontraron resultados'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildHeader(),
          const SizedBox(height: 16),
          buildList(),
          buildPager(),
        ],
      ),
    );
  }

  Expanded buildList() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          final character = characters[index];
          return Card(
            child: CharacterWidget(character:  character),
          );
        },
      ),
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        buildSearchField(),
        const SizedBox(width: 8),
        buildFavoritesButton(),
      ],
    );
  }

  Expanded buildSearchField() {
    return Expanded(
      child: TextField(
        decoration: const InputDecoration(hintText: 'Nombre del personaje...'),
        onChanged: (value) {
          setState(() {
            characterName = value;
            pageIndex = 1;
          });
          filter = Filter(name: characterName, index: pageIndex);
          _bloc.add(ActionGetCharacters(filter: filter));
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      ],
    );
  }
}

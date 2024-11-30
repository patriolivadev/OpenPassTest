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

  List characters = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(ActionGetFavoriteCharacters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
    if (state is OnGetFavoriteCharacters) {
      characters = state.characters;
      setState(() {});
    }

    if (state is OnSaveFavoriteCharacter) {
      for (var element in characters) {
        if (element.id == state.id) {
          element.isFavorite = true;
        }
      }
    }

    if (state is OnRemoveFavoriteCharacter) {
      for (var element in characters) {
        if (element.id == state.id) {
          element.isFavorite = false;
        }
      }
    }
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

    if (characters.isEmpty) {
      return const Center(
        child: Text('Aún no hay favoritos guardados.'),
      );
    }

    return Column(
      children: [
        Expanded(child: buildList()),
        const SizedBox(
          height: 10,
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
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          child: CharacterWidget(character: character),
        );
      },
    );
  }
}

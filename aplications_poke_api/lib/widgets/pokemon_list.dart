import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;
  final Function(Pokemon) onPokemonTap;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const PokemonList({
    super.key,
    required this.pokemons,
    required this.onPokemonTap,
    this.isLoading = false,
    this.onLoadMore,
  });
// widgets principal 
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (onLoadMore != null &&
            isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore!();
        }

        return false;
      },
      //contenido de la pantalla visual 
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ), // SliverGridDelegateWithFixedCrossAxisCount
              padding: const EdgeInsets.all(8),
              itemCount: pokemons.length + (isLoading ? 1 : 0),
// construccion de item               
              itemBuilder: (context, index) {
                if (index == pokemons.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final pokemon = pokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () => onPokemonTap(pokemon),
                ); // PokemonCard
              }, // itemBuilder
            ), // GridView.builder
          ), // Expanded
        ], // Children
      ), // Column
    ); // NotificationListener
  }
}

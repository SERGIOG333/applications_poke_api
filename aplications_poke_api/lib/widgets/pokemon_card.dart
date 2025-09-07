import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  Color _getTypeColor(String type) {
    final colors = {
      'normal': Colors.brown[400],
      'fire': Colors.red[400],
      'water': Colors.blue[400],
      'electric': Colors.yellow[600],
      'grass': Colors.green[400],
      'ice': Colors.cyan[300],
      'fighting': Colors.orange[800],
      'poison': Colors.purple[400],
      'ground': Colors.amber[600],
      'flying': Colors.indigo[300],
      'psychic': Colors.pink[400],
      'bug': Colors.lightGreen[500],
      'rock': Colors.grey[600],
      'ghost': Colors.deepPurple[400],
      'dragon': Colors.indigo[800],
      'dark': Colors.brown[800],
      'steel': Colors.blueGrey[400],
      'fairy': Colors.pink[200],
    };

    return colors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ID and Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pokemon.formattedId,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ), // Text
                  Text(
                    pokemon.capitalizedName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Text
                ],
              ), // Row
              const SizedBox(height: 16),

              // Pokémon Image
              Center(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  height: 100,
                  width: 100,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ), // CachedNetworkImage
              ), // Center

              const SizedBox(height: 16),

              // Types
              Wrap(
                spacing: 8,
                children: pokemon.types.map((type) {
                  return Chip(
                    label: Text(
                      type.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ), // TextStyle
                    ), // Text
                    backgroundColor: _getTypeColor(type),
                  ); // Chip
                }).toList(),
              ), // Wrap

              const SizedBox(height: 8),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Height', '${pokemon.height / 10}m'),
                  _buildStat('Weight', '${pokemon.weight / 10}kg'),
                ], // Children
              ), // Row
            ], // Column
          ), // Padding
        ), // InkWell
      ), // Card
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey), // TextStyle
        ), // Text
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ), // TextStyle
        ), // Text
      ],
    ); // Column
  }
}

import 'package:flutter/material.dart';
import 'services/pokemon_service.dart';
import 'models/pokemon.dart';
import 'widgets/pokemon_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAPI App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PokemonHomePage(),
    );
  }
}

class PokemonHomePage extends StatefulWidget {
  const PokemonHomePage({super.key});

  @override
  State<PokemonHomePage> createState() => _PokemonHomePageState();
}

class _PokemonHomePageState extends State<PokemonHomePage> {
  final PokemonService _pokemonService = PokemonService();
  final List<Pokemon> _pokemons = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPokemons = await _pokemonService.fetchPokemons(
        limit: _limit,
        offset: _offset,
      );

      setState(() {
        _pokemons.addAll(newPokemons);
        _offset += _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar(e.toString());
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onPokemonTap(Pokemon pokemon){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pokemon.capitalizedName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(pokemon.imageUrl),
            const SizedBox(height: 16),
            Text('ID: ${pokemon.formattedId}'),
            Text('Height: ${pokemon.height/10}m'),
            Text('Weight: ${pokemon.weight/10}kg'),
            Text('Types: ${pokemon.types.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeAPI App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _pokemons.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PokemonList(
              pokemons: _pokemons,
              onPokemonTap: _onPokemonTap,
              isLoading: _isLoading,
              onLoadMore : _loadPokemons,  
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPokemons,
        child: const Icon(Icons.refresh),
      ),
    );
  }

}

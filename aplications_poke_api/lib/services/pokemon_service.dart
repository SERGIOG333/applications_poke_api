import 'package:dio/dio.dart';
import '../models/pokemon.dart';

class PokemonService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  ); // BaseOptions // Dio

    Future<List<Pokemon>> fetchPokemons({int limit = 20, int offset = 0}) async {
      try {
      final response = await _dio.get(
        'pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];

        // Fetch details for each Pokémon
        final List<Future<Pokemon>> pokemonFutures = results
            .map<Future<Pokemon>>((pokemon) async {
              final pokemonResponse = await _dio.get(pokemon['url']);
              return Pokemon.fromJson(pokemonResponse.data);
            })
            .toList();

        final List<Pokemon> pokemons = await Future.wait(pokemonFutures);
        return pokemons;
      } else {
        throw Exception('Failed to load pokemons');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Pokemon> fetchPokemonById(int id) async {
    try {
      final response = await _dio.get('pokemon/$id');

      if (response.statusCode == 200) {
        return Pokemon.fromJson(response.data);
      } else {
        throw Exception('Failed to load pokemon');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  List<Pokemon> _pokemons = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPokemons().then((value) {
      setState(() {
        _pokemons = value;
      });
    });
  }

  Future<List<Pokemon>> fetchPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      List<Pokemon> pokemons = [];
      for (var pokemon in jsonResponse) {
        final responseDetail = await http.get(Uri.parse(pokemon['url']));
        if (responseDetail.statusCode == 200) {
          pokemons.add(Pokemon.fromJson(json.decode(responseDetail.body)));
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  void _showNextPokemon() {
    setState(() {
      if (_currentIndex < _pokemons.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // Reset to start if at end of list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
      ),
      body: _pokemons.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pokemons[_currentIndex].imageUrl != null
                      ? Image.network(_pokemons[_currentIndex].imageUrl!,
                          width: 100, height: 100)
                      : Container(),
                  Text(_pokemons[_currentIndex].name ?? 'Unknown',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showNextPokemon,
                    child: Text('Next Pokémon'),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

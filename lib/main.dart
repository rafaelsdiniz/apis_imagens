import 'package:flutter/material.dart';
import 'tema.dart';
import 'telas/tela_caes.dart';
import 'telas/tela_pokemon.dart';
import 'telas/tela_personagens.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  Widget _item(BuildContext context, IconData icone, Color cor, String titulo,
      String subtitulo, Widget tela) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: IconeQuadrado(icone, cor),
    title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitulo,
      style: const TextStyle(color: Cores.secundario, fontSize: 13)),
    trailing: const Icon(Icons.chevron_right, color: Cores.secundario),
    onTap: () => Navigator.push(context,
      MaterialPageRoute(builder: (_) => tela)),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'APIs Divertidas',
    theme: tema(Cores.azul),
    home: Scaffold(
      body: SafeArea(child: Builder(builder: (context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          const Text('APIs Divertidas', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Dados reais da internet, em três telas.',
            style: TextStyle(fontSize: 15, color: Cores.secundario)),
          const SizedBox(height: 28),
          Grupo(titulo: 'Explorar', filhos: [
            _item(context, Icons.pets, Cores.laranja, 'Galeria de cães',
              'Fotos aleatórias por raça', const TelaCaes()),
            _item(context, Icons.catching_pokemon, Cores.vermelho, 'Pokédex',
              'Busque qualquer Pokémon', const TelaPokemon()),
            _item(context, Icons.people_alt, Cores.verde, 'Personagens',
              'O elenco de Rick and Morty', const TelaPersonagens()),
          ]),
          const SizedBox(height: 24),
          const Text('dog.ceo · pokeapi.co · rickandmortyapi.com',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Cores.secundario)),
        ],
      ))),
    ),
  );
}

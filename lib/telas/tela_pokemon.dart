import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../tema.dart';

const _tipos = <String, (String, Color)>{
  'normal': ('Normal', Color(0xFFA8A77A)),
  'fire': ('Fogo', Color(0xFFEE8130)),
  'water': ('Água', Color(0xFF6390F0)),
  'electric': ('Elétrico', Color(0xFFF7D02C)),
  'grass': ('Planta', Color(0xFF7AC74C)),
  'ice': ('Gelo', Color(0xFF96D9D6)),
  'fighting': ('Lutador', Color(0xFFC22E28)),
  'poison': ('Venenoso', Color(0xFFA33EA1)),
  'ground': ('Terra', Color(0xFFE2BF65)),
  'flying': ('Voador', Color(0xFFA98FF3)),
  'psychic': ('Psíquico', Color(0xFFF95587)),
  'bug': ('Inseto', Color(0xFFA6B91A)),
  'rock': ('Pedra', Color(0xFFB6A136)),
  'ghost': ('Fantasma', Color(0xFF735797)),
  'dragon': ('Dragão', Color(0xFF6F35FC)),
  'dark': ('Sombrio', Color(0xFF705746)),
  'steel': ('Aço', Color(0xFFB7B7CE)),
  'fairy': ('Fada', Color(0xFFD685AD)),
};

(String, Color) _tipo(String nome) =>
    _tipos[nome] ?? (nome, Cores.secundario);

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({super.key});

  @override
  State<TelaPokemon> createState() => _TelaPokemonState();
}

class _TelaPokemonState extends State<TelaPokemon> {
  final controle = TextEditingController(text: 'pikachu');
  Map<String, dynamic>? pokemon;
  String? erro;
  bool carregando = false;

  Future<void> buscarPokemon() async {
    final busca = controle.text.trim().toLowerCase();
    if (busca.isEmpty) {
      setState(() { erro = 'Digite um nome ou número.'; });
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() { carregando = true; erro = null; pokemon = null; });
    try {
      final resposta = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/${Uri.encodeComponent(busca)}'));
      if (resposta.statusCode != 200) throw Exception('Não encontrado');
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() { pokemon = dados; });
    } catch (e) {
      if (!mounted) return;
      setState(() { erro = 'Pokémon não encontrado ou sem conexão.'; });
    } finally {
      if (mounted) setState(() { carregando = false; });
    }
  }

  void buscarAleatorio() {
    controle.text = '${Random().nextInt(151) + 1}';
    buscarPokemon();
  }

  @override
  void dispose() { controle.dispose(); super.dispose(); }

  Widget _medida(String rotulo, String valor) => Column(children: [
    Text(valor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
    const SizedBox(height: 2),
    Text(rotulo, style: const TextStyle(fontSize: 13, color: Cores.secundario)),
  ]);

  Widget _cartao() {
    final sprite = pokemon?['sprites']?['front_default'];
    final tipos = (pokemon!['types'] as List<dynamic>)
        .map((t) => t['type']['name'] as String)
        .toList();
    final corPrincipal = _tipo(tipos.isEmpty ? '' : tipos.first).$2;
    final nome = '${pokemon!['name']}';
    final altura = (pokemon!['height'] / 10).toStringAsFixed(1).replaceAll('.', ',');
    final peso = (pokemon!['weight'] / 10).toStringAsFixed(1).replaceAll('.', ',');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(
          width: double.infinity,
          color: corPrincipal.withValues(alpha: 0.18),
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Align(alignment: Alignment.centerRight,
              child: Text('#${'${pokemon!['id']}'.padLeft(3, '0')}',
                style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w700, color: Cores.secundario))),
            if (sprite != null) Image.network(sprite,
              width: 180, height: 180, fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
              errorBuilder: (_, _, _) => const Aviso(Icons.image_not_supported, 'Sem imagem')),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text('${nome[0].toUpperCase()}${nome.substring(1)}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: tipos.map((t) {
                final (rotulo, cor) = _tipo(t);
                final claro = cor.computeLuminance() > 0.5;
                return Chip(
                  label: Text(rotulo),
                  backgroundColor: cor,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600,
                    color: claro ? Cores.texto : Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _medida('Altura', '$altura m')),
              Container(width: 0.5, height: 36, color: Cores.separador),
              Expanded(child: _medida('Peso', '$peso kg')),
            ]),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: tema(Cores.vermelho),
    child: Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controle,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => buscarPokemon(),
            decoration: const InputDecoration(
              hintText: 'Nome ou número do Pokémon',
              prefixIcon: Icon(Icons.search, color: Cores.secundario)),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ElevatedButton(
              onPressed: carregando ? null : buscarPokemon,
              child: const Text('Buscar'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton.icon(
              onPressed: carregando ? null : buscarAleatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.vermelho.withValues(alpha: 0.12),
                foregroundColor: Cores.vermelho),
              icon: const Icon(Icons.shuffle),
              label: const Text('Aleatório'))),
          ]),
          const SizedBox(height: 20),
          if (carregando) const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator.adaptive())),
          if (erro != null) Aviso(Icons.search_off, erro!),
          if (pokemon != null) _cartao(),
          if (pokemon == null && erro == null && !carregando)
            const Aviso(Icons.catching_pokemon,
              'Digite um nome ou número,\nou toque em Aleatório.'),
        ],
      ),
    ),
  );
}

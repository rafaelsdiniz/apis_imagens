import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../tema.dart';

// Exercício 1: fundo creme, análogo ao laranja de destaque
const _fundoCaes = Color(0xFFFFF8F0);

class TelaCaes extends StatefulWidget {
  const TelaCaes({super.key});

  @override
  State<TelaCaes> createState() => _TelaCaesState();
}

class _TelaCaesState extends State<TelaCaes> {
  String? imagem;
  String? erro;
  bool carregando = false;
  int contador = 0; // exercício 2

  // Exercício 3: raças disponíveis (nome na API -> nome na tela)
  final racas = const {
    'hound': 'Hound',
    'husky': 'Husky',
    'pug': 'Pug',
    'labrador': 'Labrador',
  };
  String raca = 'hound';

  Future<void> buscarCao() async {
    setState(() { carregando = true; erro = null; });
    try {
      final resposta = await http.get(
        Uri.parse('https://dog.ceo/api/breed/$raca/images/random'));
      if (resposta.statusCode != 200) throw Exception('Falha na consulta');
      final dados = jsonDecode(resposta.body);
      if (!mounted) return;
      setState(() {
        imagem = dados['message'];
        contador++;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { erro = 'Não foi possível carregar a foto.\nConfira sua conexão.'; });
    } finally {
      if (mounted) setState(() { carregando = false; });
    }
  }

  Widget _foto() => AspectRatio(
    aspectRatio: 1,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Cores.cartao,
        child: Stack(fit: StackFit.expand, children: [
          if (erro != null) Center(child: Aviso(Icons.wifi_off, erro!))
          else if (imagem != null) Image.network(imagem!, fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
              const Center(child: Aviso(Icons.broken_image, 'Imagem indisponível')))
          else const Center(child: Aviso(Icons.pets, 'Sua foto aparece aqui')),
          if (carregando) Container(
            color: Colors.white70,
            child: const Center(child: CircularProgressIndicator.adaptive())),
        ]),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Theme(
    data: tema(Cores.laranja),
    child: Scaffold(
      backgroundColor: _fundoCaes,
      appBar: AppBar(
        title: const Text('Galeria de cachorros'),
        backgroundColor: _fundoCaes,
      ),
      body: SafeArea(child: Column(children: [
        Expanded(child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Escolha uma raça e conheça um novo amigo!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: racas.entries.map((r) {
                final selecionada = raca == r.key;
                return ChoiceChip(
                  label: Text(r.value),
                  selected: selecionada,
                  showCheckmark: false,
                  selectedColor: Cores.laranja.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: selecionada ? Cores.laranja : Cores.texto,
                    fontWeight: FontWeight.w600),
                  onSelected: (_) => setState(() { raca = r.key; }),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _foto(),
            const SizedBox(height: 14),
            Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: ShapeDecoration(
                color: Cores.laranja.withValues(alpha: 0.12),
                shape: const StadiumBorder()),
              child: Text(
                '🐾 $contador ${contador == 1 ? 'foto sorteada' : 'fotos sorteadas'}',
                style: const TextStyle(
                  color: Cores.laranja, fontWeight: FontWeight.w600)),
            )),
          ],
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(width: double.infinity,
            child: ElevatedButton(onPressed: carregando ? null : buscarCao,
              child: const Text('Quero ver um cachorro!'))),
        ),
      ])),
    ),
  );
}

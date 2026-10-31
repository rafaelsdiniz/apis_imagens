import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      setState(() { erro = 'Não foi possível carregar a foto.'; });
    } finally {
      if (mounted) setState(() { carregando = false; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.amber.shade50,
    appBar: AppBar(
      title: const Text('Au Au Galeria 🐶'),
      backgroundColor: Colors.amber,
    ),
    body: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Escolha uma raça e conheça um novo amigo!'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: racas.entries.map((r) => ChoiceChip(
            label: Text(r.value),
            selected: raca == r.key,
            onSelected: (_) => setState(() { raca = r.key; }),
          )).toList(),
        ),
        const SizedBox(height: 16),
        Text('Fotos sorteadas: $contador',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (carregando) const CircularProgressIndicator(),
        if (erro != null) Text(erro!),
        if (imagem != null) ...[
          const Text('Olha só quem apareceu:'),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imagem!, height: 260, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Text('Imagem indisponível'))),
        ],
        const SizedBox(height: 16),
        ElevatedButton(onPressed: carregando ? null : buscarCao,
          child: const Text('Quero ver um cachorro!')),
      ]),
    )),
  );
}

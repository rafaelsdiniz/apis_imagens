import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/personagem.dart';
import 'tela_detalhe_personagem.dart';

class TelaPersonagens extends StatefulWidget {
  const TelaPersonagens({super.key});

  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  late Future<List<Personagem>> _futuro;
  String _status = '';     // exercício 8: '' = todos, 'alive', 'dead'
  int _pagina = 1;         // exercício 9
  int _totalPaginas = 1;   // vem de info.pages
  int? _favorito;          // exercício 10

  @override
  void initState() {
    super.initState();
    _futuro = buscarPersonagens(); // pede os dados UMA vez, ao abrir a tela
    carregarFavorito();
  }

  Future<void> carregarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { _favorito = prefs.getInt('favorito'); });
  }

  Future<List<Personagem>> buscarPersonagens() async {
    var url = 'https://rickandmortyapi.com/api/character?page=$_pagina';
    if (_status.isNotEmpty) url += '&status=$_status';
    final resposta = await http.get(Uri.parse(url));
    if (resposta.statusCode != 200) {
      throw Exception('Falha na consulta: ${resposta.statusCode}');
    }
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    // o rótulo de página fica fora do FutureBuilder, então precisa de setState
    if (mounted) setState(() { _totalPaginas = dados['info']['pages']; });
    final lista = dados['results'] as List<dynamic>;
    return lista
        .map((item) => Personagem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  void _recarregar() {
    setState(() { _futuro = buscarPersonagens(); });
  }

  void _trocarStatus(String status) {
    setState(() {
      _status = status;
      _pagina = 1; // cada filtro tem sua própria quantidade de páginas
      _futuro = buscarPersonagens();
    });
  }

  void _irParaPagina(int pagina) {
    setState(() {
      _pagina = pagina;
      _futuro = buscarPersonagens();
    });
  }

  Future<void> _abrirDetalhe(Personagem p) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (_) => TelaDetalhePersonagem(personagem: p)));
    await carregarFavorito(); // atualiza a estrela ao voltar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: '', label: Text('Todos')),
              ButtonSegment(value: 'alive', label: Text('Vivos')),
              ButtonSegment(value: 'dead', label: Text('Mortos')),
            ],
            selected: {_status},
            onSelectionChanged: (s) => _trocarStatus(s.first),
          ),
        ),
        Expanded(child: FutureBuilder<List<Personagem>>(
          future: _futuro,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Não foi possível carregar os personagens.'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _recarregar,
                    child: const Text('Tentar de novo')),
                ]),
              );
            }
            final personagens = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: personagens.length,
              itemBuilder: (context, i) {
                final p = personagens[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(p.imagem)),
                    title: Text(p.nome),
                    subtitle: Text('${p.especie} · ${p.status}'),
                    trailing: p.id == _favorito
                        ? const Icon(Icons.star, color: Colors.amber)
                        : const Icon(Icons.chevron_right),
                    onTap: () => _abrirDetalhe(p),
                  ),
                );
              },
            );
          },
        )),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _pagina > 1 ? () => _irParaPagina(_pagina - 1) : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Anterior')),
              Text('Página $_pagina de $_totalPaginas'),
              ElevatedButton.icon(
                onPressed: _pagina < _totalPaginas
                    ? () => _irParaPagina(_pagina + 1) : null,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Próxima')),
            ]),
        ),
      ]),
    );
  }
}

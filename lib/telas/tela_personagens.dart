import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/personagem.dart';
import '../tema.dart';
import 'tela_detalhe_personagem.dart';

class TelaPersonagens extends StatefulWidget {
  const TelaPersonagens({super.key});

  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  late Future<List<Personagem>> _futuro;
  String _status = '';
  int _pagina = 1;
  int _totalPaginas = 1;
  int? _favorito;

  @override
  void initState() {
    super.initState();
    _futuro = buscarPersonagens();
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
      _pagina = 1;
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
    await carregarFavorito();
  }

  Widget _botaoPagina(IconData icone, String dica, VoidCallback? acao) =>
    IconButton(
      onPressed: acao,
      tooltip: dica,
      style: IconButton.styleFrom(
        backgroundColor: Cores.verde.withValues(alpha: 0.12),
        foregroundColor: Cores.verde,
        disabledBackgroundColor: Cores.separador),
      icon: Icon(icone),
    );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: tema(Cores.verde),
      child: Scaffold(
        appBar: AppBar(title: const Text('Personagens')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(width: double.infinity,
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _status,
                children: const {
                  '': Text('Todos'),
                  'alive': Text('Vivos'),
                  'dead': Text('Mortos'),
                },
                onValueChanged: (s) => _trocarStatus(s ?? ''),
              )),
          ),
          Expanded(child: FutureBuilder<List<Personagem>>(
            future: _futuro,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Aviso(Icons.wifi_off,
                      'Não foi possível carregar os personagens.'),
                    ElevatedButton(onPressed: _recarregar,
                      child: const Text('Tentar de novo')),
                  ]),
                );
              }
              final personagens = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: personagens.length,
                itemBuilder: (context, i) {
                  final p = personagens[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(p.imagem)),
                        title: Text(p.nome,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Row(children: [
                          Icon(Icons.circle, size: 8, color: corDoStatus(p.status)),
                          const SizedBox(width: 6),
                          Flexible(child: Text(
                            '${statusEmPortugues(p.status)} · ${p.especie}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Cores.secundario))),
                        ]),
                        trailing: p.id == _favorito
                            ? const Icon(Icons.star, color: Cores.amarelo)
                            : const Icon(Icons.chevron_right,
                                color: Cores.secundario),
                        onTap: () => _abrirDetalhe(p),
                      ),
                    ),
                  );
                },
              );
            },
          )),
          SafeArea(top: false, child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              _botaoPagina(Icons.chevron_left, 'Página anterior',
                _pagina > 1 ? () => _irParaPagina(_pagina - 1) : null),
              Expanded(child: Text('Página $_pagina de $_totalPaginas',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Cores.secundario))),
              _botaoPagina(Icons.chevron_right, 'Próxima página',
                _pagina < _totalPaginas ? () => _irParaPagina(_pagina + 1) : null),
            ]),
          )),
        ]),
      ),
    );
  }
}

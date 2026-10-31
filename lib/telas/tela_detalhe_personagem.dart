import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/personagem.dart';
import '../tema.dart';

Color corDoStatus(String status) {
  switch (status) {
    case 'Alive': return const Color(0xFF34C759);
    case 'Dead': return Cores.vermelho;
    case 'unknown': return Colors.orange;
    default: return Cores.secundario;
  }
}

String statusEmPortugues(String status) {
  switch (status) {
    case 'Alive': return 'Vivo';
    case 'Dead': return 'Morto';
    default: return 'Desconhecido';
  }
}

String _generoEmPortugues(String genero) {
  switch (genero) {
    case 'Male': return 'Masculino';
    case 'Female': return 'Feminino';
    case 'Genderless': return 'Sem gênero';
    default: return 'Desconhecido';
  }
}

class TelaDetalhePersonagem extends StatefulWidget {
  final Personagem personagem;
  const TelaDetalhePersonagem({super.key, required this.personagem});

  @override
  State<TelaDetalhePersonagem> createState() => _TelaDetalhePersonagemState();
}

class _TelaDetalhePersonagemState extends State<TelaDetalhePersonagem> {
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    carregarFavorito();
  }

  Future<void> carregarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      favorito = prefs.getInt('favorito') == widget.personagem.id;
    });
  }

  Future<void> alternarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    if (favorito) {
      await prefs.remove('favorito');
    } else {
      await prefs.setInt('favorito', widget.personagem.id);
    }
    if (!mounted) return;
    setState(() { favorito = !favorito; });
  }

  Widget _linha(IconData icone, Color cor, String rotulo, String valor) =>
    ListTile(
      leading: IconeQuadrado(icone, cor),
      title: Text(rotulo,
        style: const TextStyle(fontSize: 13, color: Cores.secundario)),
      subtitle: Text(valor,
        style: const TextStyle(fontSize: 16, color: Cores.texto)),
    );

  @override
  Widget build(BuildContext context) {
    final personagem = widget.personagem;
    final cor = corDoStatus(personagem.status);
    return Theme(
      data: tema(Cores.verde),
      child: Scaffold(
        appBar: AppBar(title: Text(personagem.nome)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(personagem.imagem,
                width: 200, height: 200, fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                  const Icon(Icons.broken_image, size: 120)),
            )),
            const SizedBox(height: 16),
            Text(personagem.nome, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: ShapeDecoration(
                color: cor.withValues(alpha: 0.12), shape: const StadiumBorder()),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 9, color: cor),
                const SizedBox(width: 6),
                Text(statusEmPortugues(personagem.status),
                  style: TextStyle(color: cor, fontWeight: FontWeight.w600)),
              ]),
            )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: alternarFavorito,
              style: favorito ? ElevatedButton.styleFrom(
                backgroundColor: Cores.amarelo.withValues(alpha: 0.18),
                foregroundColor: const Color(0xFF8A6100)) : null,
              icon: Icon(favorito ? Icons.star : Icons.star_border),
              label: Text(favorito ? 'Seu favorito' : 'Marcar como favorito'),
            ),
            const SizedBox(height: 6),
            const Text('Você pode ter um favorito por vez.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Cores.secundario)),
            const SizedBox(height: 24),
            Grupo(titulo: 'Informações', filhos: [
              _linha(Icons.category, Cores.azul, 'Espécie', personagem.especie),
              _linha(Icons.wc, Cores.roxo, 'Gênero',
                _generoEmPortugues(personagem.genero)),
              _linha(Icons.public, Cores.laranja, 'Origem', personagem.origem),
              _linha(Icons.location_on, Cores.vermelho, 'Localização atual',
                personagem.localizacao),
              _linha(Icons.tag, Cores.secundario, 'ID', '${personagem.id}'),
            ]),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta inspirada nas cores de sistema do iOS. Cada tela usa UMA cor de
// destaque e o resto fica em tons neutros, para a cor aparecer só onde o
// usuário pode tocar ou no que está selecionado.
class Cores {
  static const fundo = Color(0xFFF2F2F7);
  static const cartao = Colors.white;
  static const texto = Color(0xFF1C1C1E);
  static const secundario = Color(0xFF8E8E93);
  static const separador = Color(0xFFE5E5EA);
  static const azul = Color(0xFF007AFF);
  static const laranja = Color(0xFFE67700);
  static const vermelho = Color(0xFFE5332A);
  static const verde = Color(0xFF248A3D);
  static const roxo = Color(0xFFAF52DE);
  static const amarelo = Color(0xFFFFB800);
}

ThemeData tema(Color cor) {
  final base = ThemeData(
    useMaterial3: true,
    platform: TargetPlatform.iOS, // transições e seta de voltar do iPhone
    scaffoldBackgroundColor: Cores.fundo,
    fontFamily: GoogleFonts.inter().fontFamily, // fonte parecida com a do iPhone
    colorScheme: ColorScheme.fromSeed(seedColor: cor).copyWith(
      primary: cor, onPrimary: Colors.white, surface: Cores.cartao),
  );
  return base.copyWith(
    textTheme: base.textTheme
        .apply(bodyColor: Cores.texto, displayColor: Cores.texto),
    appBarTheme: AppBarTheme(
      backgroundColor: Cores.fundo,
      foregroundColor: cor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: base.textTheme.titleMedium?.copyWith(
        fontSize: 17, fontWeight: FontWeight.w600, color: Cores.texto),
    ),
    cardTheme: CardThemeData(
      color: Cores.cartao,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Cores.separador,
        elevation: 0,
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: base.textTheme.titleMedium?.copyWith(
          fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Cores.cartao,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Cores.cartao,
      side: BorderSide.none,
      shape: StadiumBorder(),
    ),
    dividerTheme: const DividerThemeData(
      color: Cores.separador, thickness: 0.5, space: 0.5),
  );
}

// Ícone branco em um quadrado colorido, como nos Ajustes do iPhone
class IconeQuadrado extends StatelessWidget {
  final IconData icone;
  final Color cor;
  const IconeQuadrado(this.icone, this.cor, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: cor, borderRadius: BorderRadius.circular(8)),
    child: Icon(icone, color: Colors.white, size: 19),
  );
}

// Lista agrupada (inset grouped) do iOS: título pequeno e itens num cartão
class Grupo extends StatelessWidget {
  final String? titulo;
  final List<Widget> filhos;
  const Grupo({super.key, this.titulo, required this.filhos});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (titulo != null) Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 6),
        child: Text(titulo!.toUpperCase(), style: const TextStyle(
          fontSize: 13, color: Cores.secundario, letterSpacing: 0.3)),
      ),
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          for (var i = 0; i < filhos.length; i++) ...[
            filhos[i],
            if (i < filhos.length - 1) const Divider(indent: 64),
          ],
        ]),
      ),
    ],
  );
}

// Mensagem central com ícone, usada para vazio e erro
class Aviso extends StatelessWidget {
  final IconData icone;
  final String texto;
  const Aviso(this.icone, this.texto, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icone, size: 44, color: Cores.secundario.withValues(alpha: 0.6)),
      const SizedBox(height: 10),
      Text(texto, textAlign: TextAlign.center,
        style: const TextStyle(color: Cores.secundario, fontSize: 15)),
    ]),
  );
}

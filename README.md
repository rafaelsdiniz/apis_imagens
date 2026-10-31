# APIs Divertidas em Flutter

Aplicativo Flutter que consome três APIs públicas, desenvolvido na aula prática de **Dispositivos Móveis I**, ministrada pela Profª. Madianita Bogo Marioti.

**Aluno:** Rafael Silva Diniz

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

## Funcionalidades

| Tela | Descrição | API |
|------|-----------|-----|
| Galeria de cachorros | Sorteia fotos da raça escolhida e conta quantas fotos já foram sorteadas | [Dog CEO](https://dog.ceo/dog-api/) |
| Pokédex | Busca por nome ou número, ou sorteia um dos 151 primeiros, e exibe ID, imagem, tipos, altura e peso | [PokéAPI](https://pokeapi.co/) |
| Personagens | Lista paginada com filtro por status. O detalhe mostra espécie, gênero, origem e localização, e permite marcar um favorito | [Rick and Morty API](https://rickandmortyapi.com/) |

## Exercícios do Passo 8

| Nº | Nível | Exercício | Arquivo |
|:--:|-------|-----------|---------|
| 1 | Básico | Personalização da galeria: título, cor de fundo, texto do botão e frase acima da imagem | `tela_caes.dart` |
| 2 | Básico | Contador de fotos sorteadas | `tela_caes.dart` |
| 3 | Médio | Escolha da raça com `ChoiceChip` em um `Wrap` | `tela_caes.dart` |
| 4 | Básico | ID do Pokémon e resultado dentro de um `Card` | `tela_pokemon.dart` |
| 5 | Médio | Pokémon aleatório entre 1 e 151 | `tela_pokemon.dart` |
| 6 | Médio | Tipos do Pokémon exibidos como `Chip` | `tela_pokemon.dart` |
| 7 | Básico | Gênero e localização atual na tela de detalhe | `personagem.dart`, `tela_detalhe_personagem.dart` |
| 8 | Médio | Filtro por status: todos, vivos e mortos | `tela_personagens.dart` |
| 9 | Desafio | Navegação entre páginas usando `info.pages` | `tela_personagens.dart` |
| 10 | Desafio | Favorito persistente com `SharedPreferences`, indicado por estrela na lista | `tela_detalhe_personagem.dart`, `tela_personagens.dart` |

## Conceitos aplicados

- Requisições GET com o pacote `http` e `async`/`await`
- Conversão de JSON simples, aninhado e em lista com `jsonDecode`
- Classe modelo com construtor `fromMap`
- Estados de carregamento e erro com `setState`, `try`/`catch`/`finally` e `mounted`
- `FutureBuilder` com o `Future` criado no `initState`
- `ListView.builder`, `Card`, `ListTile`, `Chip` e `ChoiceChip`
- Passagem de objetos entre telas com `Navigator.push`
- Persistência local com `SharedPreferences`

## Interface

O layout segue o padrão visual do iOS: fundo cinza de sistema, listas agrupadas, controle segmentado e transições nativas do iPhone. Cada tela usa uma única cor de destaque (azul na tela inicial, laranja na galeria, vermelho na Pokédex e verde nos personagens), e os demais elementos ficam em tons neutros. Na Pokédex, o cartão assume a cor do tipo do Pokémon.

## Estrutura

```
lib/
├── main.dart
├── tema.dart
├── modelos/
│   └── personagem.dart
└── telas/
    ├── tela_caes.dart
    ├── tela_pokemon.dart
    ├── tela_personagens.dart
    └── tela_detalhe_personagem.dart
```

## Execução

```bash
git clone https://github.com/rafaelsdiniz/apis_imagens.git
cd apis_imagens
flutter pub get
flutter run
```

A permissão de internet está declarada em `android/app/src/main/AndroidManifest.xml`.

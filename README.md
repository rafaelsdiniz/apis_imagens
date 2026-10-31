<div align="center">

# 🐶 ⚡ 🛸 APIs Divertidas em Flutter

**Aplicativo Flutter que consome três APIs públicas: cães, Pokémon e Rick and Morty**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

Dispositivos Móveis I · Aula prática · Profª. Madianita Bogo Marioti

</div>

---

## 👤 Aluno

**Rafael Silva Diniz**

---

## 📱 Sobre o app

Um único projeto (`apis_imagens`) com uma tela inicial e três telas que buscam dados reais na internet:

| Tela | O que faz | API |
|------|-----------|-----|
| 🐶 **Galeria de cães** | Sorteia fotos de cachorro da raça escolhida e conta quantas já saíram | [dog.ceo](https://dog.ceo/dog-api/) |
| ⚡ **Pokédex** | Busca por nome ou número, ou sorteia um dos 151 primeiros; mostra ID, imagem, tipos, altura e peso | [pokeapi.co](https://pokeapi.co/) |
| 🛸 **Personagens** | Lista paginada com filtro por status; o detalhe mostra gênero, origem, localização e permite favoritar | [rickandmortyapi.com](https://rickandmortyapi.com/) |

## 🧠 Conceitos praticados

- Requisições **GET** com o pacote `http` e `async` / `await`
- **JSON** simples, aninhado e em lista, convertido com `jsonDecode`
- Classe modelo com `factory fromMap`
- Estados de **carregando** e **erro** com `setState`, `try` / `catch` / `finally` e `mounted`
- `FutureBuilder`, `ListView.builder`, `Card`, `ListTile`, `Chip`, `ChoiceChip`, `SegmentedButton`
- Navegação passando objetos pelo construtor (`Navigator.push`)
- Persistência local com **SharedPreferences**

## ✅ Exercícios do Passo 8

| # | Nível | Exercício | Onde |
|:-:|:-----:|-----------|------|
| 1 | 🟢 Básico | Galeria personalizada: título, cor de fundo, texto do botão e frase acima da imagem | `tela_caes.dart` |
| 2 | 🟢 Básico | Contador de fotos sorteadas | `tela_caes.dart` |
| 3 | 🟡 Médio | Escolha da raça com `ChoiceChip` em um `Wrap` | `tela_caes.dart` |
| 4 | 🟢 Básico | ID do Pokémon e resultado dentro de um `Card` | `tela_pokemon.dart` |
| 5 | 🟡 Médio | Botão de Pokémon aleatório (1 a 151) | `tela_pokemon.dart` |
| 6 | 🟡 Médio | Tipos do Pokémon como `Chip` | `tela_pokemon.dart` |
| 7 | 🟢 Básico | Gênero e localização atual no detalhe | `personagem.dart`, `tela_detalhe_personagem.dart` |
| 8 | 🟡 Médio | Filtro por status: todos, vivos e mortos | `tela_personagens.dart` |
| 9 | 🔴 Desafio | Botões de página anterior e próxima (usa `info.pages`) | `tela_personagens.dart` |
| 10 | 🔴 Desafio | Favorito que não some: estrela na lista, salvo com `SharedPreferences` | `tela_detalhe_personagem.dart`, `tela_personagens.dart` |

## 🗂️ Estrutura

```
lib/
 ├── main.dart                         tela inicial com os três botões
 ├── modelos/
 │    └── personagem.dart              classe Personagem com fromMap
 └── telas/
      ├── tela_caes.dart                galeria de cães
      ├── tela_pokemon.dart             Pokédex
      ├── tela_personagens.dart         lista, filtro e paginação
      └── tela_detalhe_personagem.dart  detalhe e favorito
```

## ▶️ Como rodar

```bash
git clone https://github.com/rafaelsdiniz/apis_imagens.git
cd apis_imagens
flutter pub get
flutter run
```

> A permissão `INTERNET` já está declarada em `android/app/src/main/AndroidManifest.xml`.

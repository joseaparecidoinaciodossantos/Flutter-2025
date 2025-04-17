
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CadastrarPostagem extends StatefulWidget {
  final String username;
  CadastrarPostagem({required this.username});
  @override
  CadastrarPostagemEstado createState() => CadastrarPostagemEstado();
}

class CadastrarPostagemEstado extends State<CadastrarPostagem> {
  final tituloControle = TextEditingController();
  final conteudoControle = TextEditingController();
  final imagemControle = TextEditingController();
  final mapsControle = TextEditingController();

  Future<void> cadastrarPostagem() async {
    final titulo = tituloControle.text;
    final conteudo = conteudoControle.text;
    final imagem = imagemControle.text;
    final mapsLink = mapsControle.text;

    if (titulo.isNotEmpty && conteudo.isNotEmpty) {
      final url = Uri.parse(
          "https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem.json");
      final resposta = await http.post(
        url,
        body: jsonEncode({
          'titulo': titulo,
          'conteudo': conteudo,
          'imagem': imagem,
          'maps': mapsLink,
          'autor': widget.username,
          'likes': 0,
          'deslikes': 0,
        }),
      );
      if (resposta.statusCode == 200) {
        tituloControle.clear();
        conteudoControle.clear();
        imagemControle.clear();
        mapsControle.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Postagem cadastrada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar postagem.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastre seu post! ',
        ),
        backgroundColor: const Color.fromARGB(255, 4, 236, 116),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloControle,
              decoration: InputDecoration(labelText: 'Título da Postagem'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: conteudoControle,
              decoration: InputDecoration(labelText: 'Conteúdo da Postagem'),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            TextField(
              controller: imagemControle,
              decoration: InputDecoration(labelText: 'Link da imagem'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: mapsControle,
              decoration: InputDecoration(
                labelText: 'Link do Google Maps',
                hintText: 'Cole aqui o link do Google Maps do local',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: cadastrarPostagem, 
              child: Text("Postar")
            ),
          ],
        ),
      ),
    );
  }
}

class VerPostagens extends StatefulWidget {
  @override
  _VerPostagensState createState() => _VerPostagensState();
}

class _VerPostagensState extends State<VerPostagens> {
  Future<List<Map<String, dynamic>>> buscarPostagens() async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem.json');
    final resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final Map<String, dynamic>? dados =
          jsonDecode(resposta.body) as Map<String, dynamic>?;
      if (dados != null) {
        final List<Map<String, dynamic>> posts = [];
        dados.forEach((key, valor) {
          posts.add({
            'id': key,
            'titulo': valor['titulo'],
            'conteudo': valor['conteudo'],
            'autor': valor['autor'],
            'imagem': valor['imagem'],
            'maps': valor['maps'] ?? '',
            'likes': valor['likes'] ?? 0,
            'deslikes': valor['deslikes'] ?? 0,
          });
        });
        return posts;
      } else {
        return [];
      }
    } else {
      throw Exception('Falha ao carregar as postagens');
    }
  }

  Future<void> _abrirMapa(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o mapa: $url';
    }
  }

  Future<void> _atualizarLikes(String postId, int newLikes) async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem/$postId.json');
    await http.patch(
      url,
      body: jsonEncode({'likes': newLikes}),
    );
    setState(() {});
  }

  Future<void> _atualizarDeslikes(String postId, int newDeslikes) async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem/$postId.json');
    await http.patch(
      url,
      body: jsonEncode({'deslikes': newDeslikes}),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver postagens!"),
        backgroundColor: const Color.fromARGB(255, 4, 236, 116),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: buscarPostagens(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar postagens!"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Sem postagens para exibir"));
          }
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: post['imagem'] == null || post['imagem'].isEmpty
                          ? SizedBox()
                          : Image.network(
                              post['imagem'],
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['titulo'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(post['conteudo']),
                          SizedBox(height: 16),
                          if (post['maps'] != null && post['maps'].isNotEmpty)
                            ElevatedButton.icon(
                              icon: Icon(Icons.map),
                              label: Text('Ver no Mapa'),
                              onPressed: () {
                                _abrirMapa(post['maps']);
                              },
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      _atualizarLikes(
                                          post['id'], (post['likes'] as int) + 1);
                                    },
                                  ),
                                  Text('${post['likes']}'),
                                  SizedBox(width: 16),
                                  IconButton(
                                    icon: Icon(Icons.thumb_down_alt_outlined),
                                    onPressed: () {
                                      _atualizarDeslikes(post['id'],
                                          (post['deslikes'] as int) + 1);
                                    },
                                  ),
                                  Text('${post['deslikes']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    color: const Color.fromARGB(255, 4, 236, 116),
                                  ),
                                  Text(
                                    "Autor: ${post['autor']}",
                                    style: TextStyle(
                                        fontSize: 14, color: const Color.fromARGB(255, 4, 236, 116)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MinhasPostagens extends StatefulWidget {
  final String username;
  MinhasPostagens({required this.username});
  @override
  MinhasPostagensEstado createState() => MinhasPostagensEstado();
}

class MinhasPostagensEstado extends State<MinhasPostagens> {
  late Future<List<Map<String, dynamic>>> futuroPost;

  Future<void> deletar(String id) async {
    final url = Uri.parse(
        "https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem/$id.json");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Postagem deletada com sucesso!')),
      );
      setState(() {
        futuroPost = buscarPostagens();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar postagem.')),
      );
    }
  }

  Future<void> _abrirMapa(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o mapa: $url';
    }
  }

  Future<void> _atualizarLikes(String postId, int newLikes) async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem/$postId.json');
    await http.patch(
      url,
      body: jsonEncode({'likes': newLikes}),
    );
    setState(() {
      futuroPost = buscarPostagens();
    });
  }

  Future<void> _atualizarDeslikes(String postId, int newDeslikes) async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem/$postId.json');
    await http.patch(
      url,
      body: jsonEncode({'deslikes': newDeslikes}),
    );
    setState(() {
      futuroPost = buscarPostagens();
    });
  }

  @override
  void initState() {
    super.initState();
    futuroPost = buscarPostagens();
  }

  Future<List<Map<String, dynamic>>> buscarPostagens() async {
    final url = Uri.parse(
        'https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem.json');
    final resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final Map<String, dynamic>? dados =
          jsonDecode(resposta.body) as Map<String, dynamic>?;
      if (dados != null) {
        final List<Map<String, dynamic>> posts = [];
        dados.forEach((key, valor) {
          if (valor['autor'] == widget.username) {
            posts.add({
              'id': key,
              'titulo': valor['titulo'],
              'conteudo': valor['conteudo'],
              'autor': valor['autor'],
              'imagem': valor['imagem'],
              'maps': valor['maps'] ?? '',
              'likes': valor['likes'] ?? 0,
              'deslikes': valor['deslikes'] ?? 0,
            });
          }
        });
        return posts;
      } else {
        return [];
      }
    } else {
      throw Exception('Falha ao carregar as postagens');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas postagens!"),
        backgroundColor: const Color.fromARGB(255, 4, 236, 116),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futuroPost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar postagens!"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Sem postagens para exibir"));
          }
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: post['imagem'] == null || post['imagem'].isEmpty
                          ? SizedBox()
                          : Image.network(
                              post['imagem'],
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['titulo'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(post['conteudo']),
                          SizedBox(height: 16),
                          if (post['maps'] != null && post['maps'].isNotEmpty)
                            ElevatedButton.icon(
                              icon: Icon(Icons.map),
                              label: Text('Ver no Mapa'),
                              onPressed: () {
                                _abrirMapa(post['maps']);
                              },
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      _atualizarLikes(
                                          post['id'], (post['likes'] as int) + 1);
                                    },
                                  ),
                                  Text('${post['likes']}'),
                                  SizedBox(width: 16),
                                  IconButton(
                                    icon: Icon(Icons.thumb_down_alt_outlined),
                                    onPressed: () {
                                      _atualizarDeslikes(post['id'],
                                          (post['deslikes'] as int) + 1);
                                    },
                                  ),
                                  Text('${post['deslikes']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    color: const Color.fromARGB(255, 4, 236, 116),
                                  ),
                                  Text(
                                    "Autor: ${post['autor']}",
                                    style: TextStyle(
                                        fontSize: 14, color:const Color.fromARGB(255, 4, 236, 116)),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  deletar(post['id']);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
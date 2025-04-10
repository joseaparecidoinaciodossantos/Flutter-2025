import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastrarPostagem extends StatefulWidget {
    final String username;
  CadastrarPostagem({required this.username});
  @override
  CadastrarPostagemEstado createState() => CadastrarPostagemEstado();

}

class CadastrarPostagemEstado extends State<CadastrarPostagem>{
  @override
  Widget build(BuildContext context) {
    final tituloControle = TextEditingController();
    final conteudoControle = TextEditingController();
    final imagemControle = TextEditingController();

    Future<void> cadastrarPostagem() async {
      final titulo = tituloControle.text;
      final conteudo = conteudoControle.text;
      final imagem = imagemControle.text;

      if(titulo.isNotEmpty && conteudo.isNotEmpty){
        //colar aonde está escrito link do banco
        final url = Uri.parse("https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem.json");
        final resposta = await http.post(
          url, body: jsonEncode({
            'titulo' : titulo,
            'conteudo' : conteudo,
            'imagem' : imagem,
            'autor': widget.username
         }),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastre seu post! ',), backgroundColor: Colors.blue, 
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
              SizedBox(height: 16,),
              TextField(
                controller: conteudoControle,
                decoration: InputDecoration(labelText: 'Conteúdo da Postagem'),
                maxLines: 4,
              ),
                SizedBox(height: 16,),
              TextField(
                controller: imagemControle,
                decoration: InputDecoration(labelText: 'Link da imagem'),
              ),
                SizedBox(height: 16,),
                ElevatedButton(onPressed: cadastrarPostagem, child: Text("Postar")),
            ],
          ),
        ),
    );
  }
}

class VerPostagens extends StatelessWidget{

  Future<List<Map<String, dynamic>>> buscarPostagens() async{
    final url = Uri.parse('https://aplicativotransito-5710d-default-rtdb.firebaseio.com/postagem.json');
    final resposta = await http.get(url);
    final Map<String, dynamic> dados = jsonDecode(resposta.body);
    //criando lista de objetos posts
    final List<Map<String, dynamic>> posts = [];
    dados.forEach((key, valor){
      posts.add({
        'titulo': valor['titulo'],
        'conteudo': valor['conteudo'],
        'autor': valor['autor'],
        'imagem': valor['imagem'],
      });
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ver postagens! ",) ,backgroundColor: Colors.blue,
      foregroundColor: Colors.white,),
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: buscarPostagens(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){ 
            return Center(child: Text("Erro ao carregar postagens!"),); 
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text("Sem postagens para exibir"));
          }
          //lista de posts
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index){
            final post = posts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    post['imagem'] == null || post['imagem'].isEmpty? SizedBox() : 
                    Image.network(post['imagem'], width: 400,) ,
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['titulo']),
                          SizedBox(height: 8,),
                          Text(post['conteudo']),
                          Text(post['autor']),
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
    ); }}
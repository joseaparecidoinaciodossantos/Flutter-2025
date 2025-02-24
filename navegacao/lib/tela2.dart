import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navegacao/tela1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TabelaPai extends StatefulWidget{
  @override
  Tabela createState() => Tabela();
  
}

class Tabela extends State<TabelaPai> {
  @override
  void initState(){
    super.initState();
    buscarPessoas();
  }
  final List<Pessoa> pessoas = [];
 // Tabela({required this.pessoas});


  Future<void> buscarPessoas() async {
    final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/pessoa.json");
    final resposta = await http.get(url);
    // decodificando o arquivijson que recebemos
    final Map<String, dynamic> ? dados = jsonDecode(resposta.body);
    print(dados);

  }


  Future<void> abrirWhats(String telefone) async {
  final url = Uri.parse('https://wa.me/$telefone');
  if (!await launchUrl(url)) {
    throw Exception('Não pode iniciar $url');
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Contatos"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        //construindo lista
        child: ListView.builder(
          itemCount: pessoas.length, //quantidade de itens da lista
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(pessoas[index].nome),
              subtitle: Text(
              "Tel: " + pessoas[index].telefone + 
              "\n Email: " + pessoas[index].email +
              "\n Endereço: " + pessoas[index].endereco +
              "\n cidade: " + pessoas[index].cidade
              ),
              trailing: IconButton(
                onPressed: () => abrirWhats(pessoas[index].telefone),
                icon: Icon(Icons.message)
              
              ),
              
            );
          }
        ),
      ),
    );
  }

  
  

}














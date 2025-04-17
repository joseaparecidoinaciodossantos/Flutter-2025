import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navegacao/detalhes.dart';
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

 //Construindo método de exclusão
 Future<void> excluir(String id) async {
final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/pessoa/$id.json");
               final resposta = await http.delete(url);

               if(resposta.statusCode == 200){
                setState(() {
                  pessoas.clear();
                  buscarPessoas();
                });
               }
 }


  Future<void> buscarPessoas() async {
    final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/pessoa.json");
    final resposta = await http.get(url);
    // decodificando o arquivijson que recebemos
    final Map<String, dynamic> ? dados = jsonDecode(resposta.body);
  if(dados != null){
    //foreach é o loop de repetiçâo que lista a um;
    dados.forEach((id, dadosPessoa){
      //aqui atualizar a lista e adicionar uma pessoa por vés
      setState(() {
        Pessoa pessoaNova = Pessoa(
          id,
          dadosPessoa["nome"] ?? '',
          dadosPessoa["email"] ?? '',
          dadosPessoa["telefone"] ?? '',
          dadosPessoa["endereco"] ?? '',
          dadosPessoa["cidade"] ?? ''
          
        );
        pessoas.add(pessoaNova);
    });

  });
  }
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
        backgroundColor: Color.fromARGB(255, 4, 236, 116),
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
               
              "Email: " + pessoas[index].email 
  
              ),
              trailing:
              Row(
              mainAxisSize:MainAxisSize.min,
              children: [
                 IconButton(
                onPressed: () => abrirWhats(pessoas[index].telefone),
                icon: Icon(Icons.message, color:const Color.fromARGB(255, 183, 184, 183),)
                 ),
                  IconButton(
                onPressed: () => excluir(pessoas[index].id),
                icon: Icon(Icons.delete_rounded, color: Colors.red,
                ),
                  ),
              ],
              
          ),//quando clicar no item da lista (onTap)
          onTap: () {

            Navigator.push(context,
            MaterialPageRoute(builder: (context) => Detalhes(pessoa: pessoas[index],)));
          },
              
              
              );

          }
              ),
             
              
            ),
  
    );
      
      
    
  }
}
  
  
















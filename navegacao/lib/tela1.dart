
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//criando a classe pessoa - que vai fabricar pessoas
class Pessoa {
  String nome;
  String email;
  String telefone;
  String endereco;
  String cidade;
  Pessoa(this.nome, this.email, this.telefone,  this.endereco, this.cidade);
}
//criando a tela de cadastro
class Cadastro extends StatefulWidget {
  final List<Pessoa> pessoas;
  //cadastro vai receber pessoas
  Cadastro({required this.pessoas});
  
  @override
  _CadastroState createState() => _CadastroState();
}
//classe que tem quantas alterações em tela forem necessárias
class _CadastroState extends State<Cadastro>{
  //controles dos inputs do formulário
  final nomeControle = TextEditingController();
  final emailControle = TextEditingController();
  final telefoneControle = TextEditingController();
  final enderecoControle = TextEditingController();
  final cidadeControle = TextEditingController();

  //criando metodo de cadastro - metodo API de post
  Future<void> cadastrarPessoa(Pessoa pessoa) async {
    final url = Uri.parse("https://aplicativotransito-5710d-default-rtdb.firebaseio.com/pessoa.json");
    final resposta = await http.post(url, body: jsonEncode({
    "nome":pessoa.nome,
    "email": pessoa.email,
    "telefone": pessoa.telefone,
    "endereco": pessoa.endereco,
    "cidade" : pessoa.cidade
    }));
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Cadastro de Pessoas"),
       backgroundColor: Colors.green,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Cadastro de Contato", style: TextStyle(fontSize: 30),),
          TextField(controller: nomeControle, decoration: InputDecoration(labelText: 'Nome')),
          TextField(controller: emailControle, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: telefoneControle, decoration: InputDecoration(labelText: 'Telefone')),
          TextField(controller: enderecoControle, decoration: InputDecoration(labelText: 'Endereço')),
          TextField(controller: cidadeControle, decoration: InputDecoration(labelText: 'Cidade')),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              //setState atualiza toda tela na hora
              setState(() { 
                //criação de um novo objeto pessoa "Ex: Seu Arlindo"
                Pessoa pessoaNova = Pessoa(
                  nomeControle.text,
                  emailControle.text,
                  telefoneControle.text,
                  enderecoControle.text,
                  cidadeControle.text,
              );
                //adicionando pessoa na lista "Ex: Seu Arlindo"
               // widget.pessoas.add(pessoaNova);
                cadastrarPessoa(pessoaNova);
                
                //limpar os campos
                nomeControle.clear();
                emailControle.clear();
                telefoneControle.clear();
                enderecoControle.clear();
                cidadeControle.clear();
              });
            },
            child: Text("Salvar"), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
            ),
            
          ),
        ],
      ),
    ),
  );
}
}


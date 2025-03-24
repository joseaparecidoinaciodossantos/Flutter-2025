import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(Preconfiguracao());

}
class Preconfiguracao extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),

      home: Login(),
    );// MaterialApp
  }
}

class Login extends StatefulWidget{
 @override
 LoginEstado createState() => LoginEstado();

    
  }


@override
class LoginEstado extends State<Login>{
  final emailControle = TextEditingController();
 final senhaControle = TextEditingController();
  bool estaCarregando = false;
  String mensagemErro = '';
  bool ocultado = true;

  Future<void> logar() async{
    setState(() {

    //inicia animação de carregamento
    estaCarregando = true;
    mensagemErro = '';
  });

  final url = Uri.parse('https://aplicativotransito-5710d-default-rtdb.firebaseio.com/usuario.json');
  final resposta = await http.get(url);
  //se tudo estiver certo...override
    // TODO: implement ==
    if(resposta.statusCode== 200){
      final Map<String, dynamic>? dados = jsonDecode(resposta.body);

if(dados != null){
   bool usuarioValido = false;
   String nomeUsuario = '';

      dados.forEach(key, valor){
        if(valor['email'] == emailControle.text && valor['senha'] == senhaControle.text){
          usuarioValido == true;
          nomeUsuario = valor['usuario'];
        }
      });
    }
    //se o usuario for valido, ou seja ,se tiver no banco
    if(usuarioValido = true){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Apliactivo));
    }

}
    }else{
      setState(() { mensagemErro = 'Erro de conexão'; });
        
      }
}
       
  @override

  Widget build(BuildContext context) {
    
    return Scaffold(

    appBar: AppBar(title: Text('Tela de Login'),
    backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),

    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_pin, size: 100, color: Colors.blue,),
          SizedBox(height: 20,),
          TextField(
            controller: emailControle,
            decoration: InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              prefixIconColor: Colors.blue,

            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: senhaControle,
            obscureText: ocultado,
            decoration: InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              prefixIconColor: Colors.blue,
              suffixIcon: IconButton(
                icon: Icon (ocultado ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    ocultado = !ocultado;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 30,),
          estaCarregando ? CircularProgressIndicator() :
          ElevatedButton(onPressed: null, child: Text('Entrar')),
         TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
              }, child: Text('Não tem uma conta? cadastre-se'),),    
        ]
    ),
    ),
    );
  }

}

class Cadastro extends StatefulWidget {
  @override
  CadastroEstado createState() => CadastroEstado();
}

class CadastroEstado extends State<Cadastro> {
  final nomeControle = TextEditingController();
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  bool estaCarregando = false;
  String erro='';
  bool ocultado = true;

  Future<void> cadastrar() async{
    //iniciar carregamento
    setState(() { estaCarregando = true; });

    final nome = nomeControle.text;
    final email = emailControle.text;
    final senha = senhaControle.text;

    final url = Uri.parse('https://aplicativotransito-5710d-default-rtdb.firebaseio.com/usuario.json');
    final resposta = await http.post(
      url,
      body:jsonEncode({
        'nome' : nome,
        'email' : email,
        'senha' : senha
      }),
      headers:{'Content-Type' : 'application/json'},
    );
    if(resposta.statusCode == 200){
      Navigator.pop(context); 
    }else{
      setState(() {
        erro = "erro ao cadastrar usúario";
      });
      setState(() {
        estaCarregando = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de novo usuario'),
      backgroundColor: Colors.blue,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
         child: Column(
          children: [
               Icon(Icons.person_pin, size: 100, color: Colors.blue,),
            SizedBox(height: 20,),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                 labelText:'email',
                 border: OutlineInputBorder(),
               prefixIcon: Icon(Icons.email),
               prefixIconColor: Colors.blue, 
               ),
            ),
            SizedBox(height: 20,),
             TextField(
              controller: nomeControle,
              decoration: InputDecoration(
                labelText:'Seu nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                prefixIconColor:Colors.blue,   
               ),
            ),

            SizedBox(height: 20,),
               TextField(
                controller:senhaControle,
                obscureText: ocultado,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Colors.blue,
                  suffixIcon: IconButton(
                    icon: Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {setState(() {ocultado = !ocultado;
                      });
                    },            
                  ),
                ),
               ),
              SizedBox(height: 30,),
             estaCarregando ? CircularProgressIndicator() : ElevatedButton(
              onPressed: cadastrar, child: Text('Cadastrar'),
              ),
              erro.isNotEmpty ? Text(erro, style: TextStyle(color:Colors.red)): SizedBox(),
          ],
         ),
         ),
    ); 
  }
}


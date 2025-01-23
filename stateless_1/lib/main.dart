import 'package:flutter/material.dart';

void main() {
  runApp( Aplicativo());
}
//criando minha classe própria
class Aplicativo extends StatelessWidget{
const Aplicativo({super.key});
//@override quer dizer que vai sobrescrever a tela
//buil é o widget que vai construir toda a tela
//materialApp é o que personaliza o tema
//
@override
  Widget build(BuildContext context) {
    
    return MaterialApp(
    theme: ThemeData.dark(),
    // Home é a primeira tela que carrega
    home: Scaffold(appBar: AppBar(

      leading: Icon(Icons.apple, size: 50),
      title: Text('flutter é divertido'),
      backgroundColor: Colors.greenAccent,
    ),//AppBarr
    //body é o corpo e center é centralizar

    body: Center(
      child: Column(
      //children serve para colocar vários widgets um atrás do outro
      children: [
        Container(
          
          color: Color.fromARGB(255, 52, 52, 91),
          height: 200,
          width: 200,
          margin: EdgeInsets.only(top: 75),
          child: Text(" Óla Mundo",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30 ),

          
          ),
        ),
          
      ],
    ),
    ),
    ),

    ); //MaterialApp
  }

} 
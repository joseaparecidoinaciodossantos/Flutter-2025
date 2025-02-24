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
    debugShowCheckedModeBanner: false,
    // Home é a primeira tela que carrega
    home: Scaffold(appBar: AppBar(

      leading: Icon(Icons.apple, size: 50),
      title: Text('flutter é divertido'),
      backgroundColor: const Color.fromARGB(255, 69, 70, 69),
    ),//AppBarr
    //body é o corpo e center é centralizar

    body: Center(
      child: Column(
      //children serve para colocar vários widgets um atrás do outro
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          
          
          height: 200,
          width: 200,
          margin: EdgeInsets.only(top: 75),

          decoration:BoxDecoration(
            color: Color.fromARGB(255, 52, 52,  91),
            borderRadius: BorderRadius.all( Radius.circular( 10)),


          ),
          child: Text(" Óla Mundo",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30 ),

          
          ),
        ),


          // widget de linha
        Row(

          // tipo de espaçamento

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.leaderboard, color: Colors. deepPurpleAccent, size: 50,),
            Icon(Icons.person, color: Colors.deepPurpleAccent, size: 50,),


          ],
        ),

        Row(

        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        
          
        FloatingActionButton(
        child: Icon(Icons. add),
        onPressed:()  {
         print( "Parabéns, Funcionou!");
        },
        
    
        
        ),

        ],
        ), 
      ],

        ),
      
    ),

    bottomNavigationBar: BottomNavigationBar(items: [
    BottomNavigationBarItem(icon: Icon( Icons.school), label: "Escola"),
    BottomNavigationBarItem(icon: Icon( Icons.add_a_photo), label: "Fotos"),
    BottomNavigationBarItem(icon: Icon( Icons.search), label: "Buscar"),

  ]),
    ),
    );
  }

} 
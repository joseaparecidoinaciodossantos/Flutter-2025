import 'package:flutter/widgets.dart';

void main(){
  runApp(Preconfiguracao());

}
class Preconfiguracao extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );// MaterialApp
  }
}
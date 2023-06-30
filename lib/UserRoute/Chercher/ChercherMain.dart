import 'package:flutter/material.dart';

import 'package:pidv1/UserRoute/Chercher/Diario/ChercherDiary.dart';
import 'Vido.dart';

class ChercherMain extends StatefulWidget {
  @override
  _ChercherMainState createState() => _ChercherMainState();
}

class _ChercherMainState extends State<ChercherMain> {
  @override
  int _indiceatual = 0;
  String Resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      Vido(),
      ChercherDiary(),

    ];
    return Scaffold(

      body: telas[_indiceatual],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceatual,
          onTap: (indice) {
            setState(() {
              _indiceatual = indice;
            });
          },
          fixedColor: Colors.blueAccent,
          unselectedItemColor: Colors.lightBlue,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                label: "Perfil",
                icon: Icon(Icons.person_pin_rounded)
            ),

            BottomNavigationBarItem(
                label: "Diário",
                icon: Icon(Icons.today
                )),

          ]),


    );
  }

}

import 'package:flutter/material.dart';
import 'package:pidv1/DoctorRoute/ChercherDoof/Vido2.dart';
import 'package:pidv1/UserRoute/Chercher/Vido.dart';

import 'PainelPaciente.dart';
class ChercherDino extends StatefulWidget {
  @override
  _ChercherDinoState createState() => _ChercherDinoState();
}

class _ChercherDinoState extends State<ChercherDino> {
  @override
  int _indiceatual = 0;
  String Resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      PainelPassageiro(),
      Vido2(),

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
          fixedColor: Colors.lightBlue,
          unselectedItemColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                label: "Criar Consulta",
                icon: Icon(Icons.add_circle)
            ),
            BottomNavigationBarItem(
                label: "Configuracões",
                icon: Icon(Icons.settings)),

          ]),


    );
  }

}
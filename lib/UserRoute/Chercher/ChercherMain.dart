import 'package:flutter/material.dart';
import 'package:pidv1/DoctorRoute/ChercherDoof/PainelPaciente.dart';
import 'package:pidv1/UserRoute/Chercher/DadosUsuario/BloodPressure.dart';
import 'package:pidv1/UserRoute/Chercher/DadosUsuario/MeusDados.dart';
import 'package:pidv1/UserRoute/Chercher/DadosUsuario/UploadDeDocumentos.dart';
import 'package:pidv1/UserRoute/Chercher/Diario/ChercherDiary.dart';
import 'package:pidv1/UserRoute/Chercher/Medicine/Reminder.dart';
import 'Notas.dart';
import 'PainelSecundario.dart';
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
      PainelSecundario(),
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
                label: "Consultas",
                icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
                label: "Diário",
                icon: Icon(Icons.today
                )),

          ]),


    );
  }

}

import 'package:flutter/material.dart';
import 'DocProfile.dart';
import 'IniciarChamada.dart';
import 'Mensagens.dart';
import 'PassarItens.dart';
class ChercherPerry extends StatefulWidget {
  String _nomeDoc;
  String _foto;
  String _idDoutor;
  String _code;
  String _idRequisicao;
  String _des;
  ChercherPerry(this._code, this._foto, this._idDoutor, this._nomeDoc, this._idRequisicao, this._des);
  @override
  _ChercherPerryState createState() => _ChercherPerryState();
}

class _ChercherPerryState extends State<ChercherPerry> {
  @override
  int _indiceatual = 0;
  String Resultado = "";
  String _minhaId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> telas = [
      DocProfile(widget._nomeDoc, widget._foto, widget._idDoutor, widget._idRequisicao, widget._des),
      Mensagens(widget._idDoutor, widget._foto, widget._nomeDoc),

      IniciarChamada(widget._code)
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
                label: "Doutor",
                icon: Icon(Icons.person_add)
            ),
            BottomNavigationBarItem(label: "Mensagens",
                icon: Icon(Icons.chat)),
            BottomNavigationBarItem(label: "Chamada",
                icon: Icon(Icons.video_call)),
          ]),


    );
  }

}
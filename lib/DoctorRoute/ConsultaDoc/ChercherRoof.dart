import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pidv1/UserRoute/Consulta/Mensagens.dart';

import 'IniciarChamadaDoc.dart';
import 'MensagensDoc.dart';
import 'Paciente.dart';
import 'ReceberItens.dart';

class ChercherRoof extends StatefulWidget {
  String _idRequisicao;
  String _code;
  ChercherRoof(this._code, this._idRequisicao);
  @override
  _ChercherRoofState createState() => _ChercherRoofState();
}

class _ChercherRoofState extends State<ChercherRoof> {
  @override
  int _indiceatual = 0;
  String Resultado = "";
  Map<String, dynamic> _dadosRequisicao = {};
  String nomePaciente = "" ;
  String fotoPaciente = "" ;
  String _doencasCronicas = "";
  String idPaciente ="";
  int _peso = 0;
  int _altura =0;
  String _nascimento = "";




  _recuperarDadosPaciente()async{
    String idRequisicao = widget._idRequisicao;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
        .doc(idRequisicao)
        .get();
    Map<String, dynamic>? _dadosRequisicao = documentSnapshot.data() as Map<String, dynamic>?;
    nomePaciente = _dadosRequisicao!["paciente"]["nome"];
    fotoPaciente = _dadosRequisicao["paciente"]["foto"];
    idPaciente = _dadosRequisicao["paciente"]["idUsuario"];
    _doencasCronicas = _dadosRequisicao["paciente"]["doencas"];
    _peso = _dadosRequisicao["paciente"]["peso"];
    _altura = _dadosRequisicao["paciente"]["altura"];
    _nascimento = _dadosRequisicao["paciente"]["nascimento"];



  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosPaciente();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [

      PacienteGeral (nomePaciente, fotoPaciente, _doencasCronicas,widget._idRequisicao, _altura, _peso, _nascimento ),
      Mensagens(idPaciente, fotoPaciente,nomePaciente ),
      ReceberItens(idPaciente),
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
          fixedColor: Colors.blueAccent,
          unselectedItemColor: Colors.lightBlueAccent,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
               label: "Meu Paciente",
               icon: Icon(Icons.local_hospital)),
            BottomNavigationBarItem(
                label: "Chat",
                icon: Icon(Icons.chat)),
            BottomNavigationBarItem(
                label: "Dados Paciente",
                icon: Icon(Icons.storage)),
            BottomNavigationBarItem(
                label: "Chamada",
                icon: Icon(Icons.video_call)),
          ]),


    );
  }

}
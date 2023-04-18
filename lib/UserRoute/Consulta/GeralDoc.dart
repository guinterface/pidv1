import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pidv1/Classes/FirebaseUser.dart';
import 'package:pidv1/Classes/StatusRequisicao.dart';
import 'package:pidv1/Classes/Usuario.dart';

import 'ChercherPerry.dart';


class GeralDoc extends StatefulWidget {
  String _nomeDoc;
  String _foto;
  String _idDoutor;
  String _code;
  String _idRequisicao;
  String _describe;

  GeralDoc(this._code, this._foto,this._idDoutor, this._nomeDoc, this._idRequisicao, this._describe);

  @override
  _GeralDocState createState() => _GeralDocState();
}

class _GeralDocState extends State<GeralDoc> {
  String _nomeDoc ="";
  bool _Aceito = false;

  _aceitarConsulta()async{
    Usuario paciente = await UsuarioFirebase.getDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    String _idRequisicao = widget._idRequisicao;
    db.collection("requisicoes")
        .doc(_idRequisicao).update({
      "paciente" : paciente.toMap(),
      "status" : StatusRequisicao.LER
    }).then((_){

      String idDoc = widget._idDoutor;
      db.collection("requisicao_ativa").doc(idDoc).update({
        "status" : StatusRequisicao.LER
      });
      String idPaciente = paciente.idUsuario;
      db.collection("requisicao_ativa_paciente").doc(idPaciente).set({
        "id_requisicao" : _idRequisicao,
        "idUsuario" : idPaciente,
        "status" : StatusRequisicao.LER
      }

      );


    });
  }
  _statusLeitura(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ChercherPerry(widget._code, widget._foto, widget._idDoutor, widget._nomeDoc, widget._idRequisicao, widget._describe)
    ));


  }
  _statusAguardando(){}
  _adicionarListenerRequisicao()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    String idRequisicao = widget._idRequisicao;
    await db.collection("requisicoes")
        .doc(idRequisicao)
        .snapshots().listen((snapshot){
      if(snapshot.data!=null){
        Map<String, dynamic>? dados = snapshot.data();
        String status = dados!["status"];
        switch(status){
          case StatusRequisicao.AGUARDANDO :
            _statusAguardando();
            break;
          case StatusRequisicao.LER :
            _statusLeitura();
            break;
          case StatusRequisicao.VIDEO :
            break;
          case StatusRequisicao.FINALIZADA :
            break;


        }

      }

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nomeDoc = widget._nomeDoc;

    _adicionarListenerRequisicao();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anuncio"),),
      body: Container(
        decoration: BoxDecoration(color: Colors.white, image: DecorationImage(
          image: AssetImage("bck1/back1000.png", ),
          fit: BoxFit.cover,

        )),
        child:Column(children: [

                  Column(


                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(12)),
                      Padding(padding: EdgeInsets.only(right: 999)),
                      CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          widget._foto != null
                              ? NetworkImage(widget._foto)
                              : null
                      ),






                    ],
                  ),






          Padding(
            padding: EdgeInsets.only(),
            child: Text(
              "Esse é o(a) Dr.",
              style: TextStyle(

                fontSize: 20,

              ),
            ),
          )
          ,
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "$_nomeDoc",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,

              ),
            ),
          )
          ,

          Padding(padding: EdgeInsets.only(top: 16),
            child:  Text(
              widget._describe,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

          ),
          Padding(
              padding: EdgeInsets.only(top: 5, left: 15, right: 16),
              child: Text(
                "Concordo em compartilhar meus dados de saúde por mim disponibilizados no aplicativo para essse profissional com fins única e exclusivamente de análise clínica e de diagnósticos"
                , style: TextStyle(
                  fontSize: 12,
                ),
              ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Checkbox(
              value: _Aceito,
              onChanged: (bool? value) {
                setState(() {
                  _Aceito = value!;
                });
              },
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: MaterialButton(

                child: Text(
                  "Iniciar Consulta",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                 color: _Aceito == true ?Colors.blueAccent : Colors.white10,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: (){

                  _Aceito == true ? _aceitarConsulta() : (){};
                }
            ),
          )


        ],)
      ),

    );
  }
}
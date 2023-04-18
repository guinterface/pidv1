
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidv1/UserRoute/Chercher/Diario/ChercherFoods.dart';
import 'package:pidv1/UserRoute/Chercher/Medicine/Reminder.dart';
import 'dart:io';

import 'package:pidv1/UserRoute/Chercher/Notas.dart';

class ChercherDiary extends StatefulWidget {
  @override
  _ChercherDiaryState createState() => _ChercherDiaryState();
}

class _ChercherDiaryState extends State<ChercherDiary> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();
  File? _imagem;
  String _idUsuarioLogado = "";
  bool _subindoImagem = false;
  String _urlImagemRecuperada = "";
  Color color = Colors.blue;
  Color backColor = Colors.yellow;






  _atualizarNomeFirestore(){

    String nome = _controllerNome.text;
    String des  = _controllerDes.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome,
      "descricao" : des
    };

    db.collection("usuarios")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );

  }



  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .doc( _idUsuarioLogado )
        .get();

    Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
    _controllerNome.text = dados!["nome"];

    if( dados["foto"] != null ){
      setState(() {
        _urlImagemRecuperada = dados["foto"];
      });

    }

  }




  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Diário"),),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Padding(padding:EdgeInsets.only(top: 10, left: 12),
                  child: Text("Aqui estão os", style: TextStyle(fontSize: 22),
                  ),),
                Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
                  child: Text("dados de sua rotina", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),),
                 Image.asset("bck1/oi.png"),
               Row(children: [

                 Padding(padding:
                 EdgeInsets.all(6),
                   child: MaterialButton(height: 120,minWidth: 170,
                     padding: EdgeInsets.all(20),
                     color: backColor,
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(
                           builder: (context) => Reminder()
                       ));
                     },
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: Row(
                       children: [
                         Icon(Icons.medication, color: color),
                         SizedBox(width: 20,),
                         Text("Meus Remédios", style: TextStyle(color: color),),
                       ],
                     ),
                   ),
                 ),
                 Padding(padding:
                 EdgeInsets.all(6),
                   child: MaterialButton(height: 120,minWidth: 170,
                     padding: EdgeInsets.all(20),
                     color: backColor,
                     onPressed: (){
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) => Notas()
                     ));},
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: Row(
                       children: [
                         Icon(Icons.person_pin, color: color,),
                         SizedBox(width: 20,),
                         Text("Eu, paciente", style: TextStyle(color: color),),
                       ],
                     ),
                   ),
                 ),


               ], )
               ,
                Row(children: [

                  Padding(padding:
                  EdgeInsets.all(6),
                    child: MaterialButton(height: 120,minWidth: 170,
                      padding: EdgeInsets.all(20),
                      color: backColor,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChercherFoods()
                        ));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.food_bank_sharp, color: color),
                          SizedBox(width: 20,),
                          Text("Pontos de Caloria", style: TextStyle(color: color),),
                        ],
                      ),
                    ),
                  ),



                ], )
                ,








              ],
            ),
          ),
        ),
      ),
    );
  }
}
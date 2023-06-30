
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidv1/UserRoute/Chercher/Diario/ChercherFoods.dart';
import 'package:pidv1/UserRoute/Chercher/Medicine/Reminder.dart';
import 'package:pidv1/UserRoute/Chercher/Notas.dart';

class ChercherDiary extends StatefulWidget {
  @override
  _ChercherDiaryState createState() => _ChercherDiaryState();
}

class _ChercherDiaryState extends State<ChercherDiary> {

  TextEditingController _controllerNome = TextEditingController();
  String _idUsuarioLogado = "";
  String _urlImagemRecuperada = "";
  Color color = Colors.blue;
  Color backColor = Colors.yellow;









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
                 Image.asset("bck1/oi.png", height: 120,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                  Padding(padding:
                  EdgeInsets.all(6),
                    child: MaterialButton(height: 80,minWidth: 300,
                      padding: EdgeInsets.all(20),
                      color: color,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChercherFoods()
                        ));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.food_bank_sharp, color: backColor),
                          SizedBox(width: 20,),
                          Text("Pontos de Caloria", style: TextStyle(color: backColor),),
                        ],
                      ),
                    ),
                  ),



                ],
                ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                 Padding(padding:
                 EdgeInsets.all(6),
                   child: MaterialButton(height: 80,minWidth: 150,
                     padding: EdgeInsets.all(15),
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
                         SizedBox(width: 10,),
                         Text("Remédios", style: TextStyle(color: color),),
                       ],
                     ),
                   ),
                 ),
                 Padding(padding:
                 EdgeInsets.all(6),
                   child: MaterialButton(height: 80,minWidth: 150,
                     padding: EdgeInsets.all(15),
                     color: backColor,
                     onPressed: (){
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) => Notas()
                     ));},
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: Row(
                       children: [
                         Icon(Icons.person_pin, color: color,),
                         SizedBox(width: 10,),
                         Text("Anotações", style: TextStyle(color: color),),
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
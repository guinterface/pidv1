import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pidv1/Classes/FirebaseUser.dart';
import 'package:pidv1/Classes/StatusRequisicao.dart';
import 'package:pidv1/UserRoute/Chercher/ChercherMain.dart';



class DocProfile extends StatefulWidget {
  String nomeDoc;
  String fotos;
  String _idDoc;
  String _idRequisicao;
  String des;
  DocProfile(this.nomeDoc, this.fotos, this._idDoc, this._idRequisicao, this.des);

  @override
  _DetalhesDocProfileState createState() => _DetalhesDocProfileState();
}

class _DetalhesDocProfileState extends State<DocProfile> {




  String _idUsuarioLogado = "";

  _recuperaDadosUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

  }
  String _foto = "";
  String _nomeDoc ="";
  _finalizarConsulta() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
        .doc(widget._idRequisicao)
        .update({
      "status" : StatusRequisicao.FINALIZADA
    });
    String _idDoutor =  widget._idDoc;
    User  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    db.collection("requisicao_ativa")
        .doc(_idDoutor)
        .update({
      "status" : StatusRequisicao.FINALIZADA
    });
    String _idPaciente =  firebaseUser.uid;
    db.collection("requisicao_ativa_paciente")
        .doc(_idPaciente)
        .update({
      "status" : StatusRequisicao.FINALIZADA
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChercherMain()
        )
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _foto = widget.fotos;
    _nomeDoc = widget.nomeDoc;
    _recuperaDadosUsuario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doutor(a)"),),
      body: Container(
        decoration: BoxDecoration(color: Colors.white, image: DecorationImage(
          image: AssetImage("bck1/back1000.png", ),
          fit: BoxFit.cover,

        )),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(14)),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                    _foto != null
                        ? NetworkImage(_foto)
                        : null
                ),
                Container(padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Esse(a) é Dr. $_nomeDoc",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),

                      Text(
                        widget.des,
                        style: TextStyle(
                            fontSize:20
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      MaterialButton(
                        child: Text("Sair da Consulta", style: TextStyle(color: Colors.white , fontSize: 20),),
                        color: Colors.red,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: (){
                          _finalizarConsulta();
                        },
                      )


                    ],
                  ),
                )

              ],

            ),
          ],
        ),
      ),

    );
  }
}
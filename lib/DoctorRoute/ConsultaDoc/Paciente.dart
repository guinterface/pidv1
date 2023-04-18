import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pidv1/Classes/FirebaseUser.dart';
import 'package:pidv1/Classes/StatusRequisicao.dart';
import 'package:pidv1/DoctorRoute/ChercherDoof/Dino.dart';
import 'package:pidv1/UserRoute/Chercher/ChercherMain.dart';
class PacienteGeral extends StatefulWidget {
  String _nome;
  String _foto;
  String _doencas;
  String _idRequisicao;
  int _altura;
  int _peso;
  String _nascimento;
  PacienteGeral(this._nome, this._foto, this._doencas, this._idRequisicao, this._altura, this._peso, this._nascimento);
  @override
  _PacienteGeralState createState() => _PacienteGeralState();

}
class _PacienteGeralState extends State<PacienteGeral> {




  _fimDaConsulta()async{
    String idRequisicao = widget._idRequisicao;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
        .doc(idRequisicao)
        .get();
    Map<String, dynamic>? _dadosRequisicao = documentSnapshot.data() as Map<String, dynamic>?;
    String idDoutor = _dadosRequisicao!["doutor"]["idUsuario"];
    db.collection("requisicao_ativa")
        .doc(idDoutor)
        .delete();

  }


  _adicionarListenerRequisicaoAtiva()async{
    User  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("requisicao_ativa")
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((snapshot){
      if(snapshot.data != null){
        Map<String, dynamic>? dados = snapshot.data();
        String status = dados!["status"];
        switch(status){
          case StatusRequisicao.AGUARDANDO :

            break;
          case StatusRequisicao.LER :

            break;
          case StatusRequisicao.VIDEO :
            break;
          case StatusRequisicao.FINALIZADA :

            break;


        }
      }else{

      }
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerRequisicaoAtiva();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Paciente"),),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                    widget._foto != null
                        ? NetworkImage(widget._foto)
                        : null
                ),
                Container(padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Seu paciente se chama ${widget._nome}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          decorationColor: Colors.blueAccent
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Nascimento:  ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        " ${widget._nascimento}" ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Peso (em kg): " ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        " ${widget._peso}" ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Altura(em cm): " ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        " ${widget._altura}" ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,

                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [

                      Text(
                        "Doenças Crônicas: " ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "${widget._doencas}" ,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,

                        ),
                      ),
                    ],
                  ),



                ],),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Padding(padding: EdgeInsets.all(12),
                        child:
                        MaterialButton(
                          child: Text("Recarregar", style: TextStyle(color: Colors.white , fontSize: 16),),
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                          ),
                          onPressed: (){
                            (context as Element).reassemble();
                            setState(() {
                              widget._nome = widget._nome;
                              widget._doencas = widget._doencas;
                            });
                          },
                        ),),
                      Padding(padding: EdgeInsets.all(0),
                      child:
                      MaterialButton(
                        child: Text("Sair da Consulta", style: TextStyle(color: Colors.white , fontSize: 16),),
                        color: Colors.red,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: (){
                          _fimDaConsulta();

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChercherDino()
                          ));
                        },
                      ),)



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
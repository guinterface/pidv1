import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidv1/Classes/FirebaseUser.dart';
import 'package:pidv1/Classes/Requisiciao.dart';
import 'package:pidv1/Classes/StatusRequisicao.dart';
import 'package:pidv1/Classes/Usuario.dart';
import 'package:pidv1/DoctorRoute/ConsultaDoc/ChercherRoof.dart';
import 'package:pidv1/UserRoute/Inicio.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';



class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  String _idRequisicao = "";
  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Inicio()

    )
    );

  }


  _escolhaMenuItem( String escolha ){

    switch( escolha ){
      case "Deslogar" :
        _deslogarUsuario();
        break;
      case "Configurações" :

        break;
    }

  }

  String _textoBotao = "Criar Consulta";
  String _imageni = "bck1/bck13.png";
  Color _corBotao = Colors.blueAccent;
  Function _funcaoBotao = (){


  } ;
  _alterarBotao(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });

  }
  _statusSemConsulta() {
    _alterarBotao("Criar Consulta", Colors.blueAccent, () {
      _criarConsulta();


    });
  }
  _cancelarConsulta() async {
    User firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
        .doc(_idRequisicao).update({
      "status" : StatusRequisicao.CANCELADA
    }).then((_){
      db.collection("requisicao_ativa").doc(firebaseUser.uid).delete();
    });
    setState(() {
      _imageni = "bck1/bck13.png";
    });
  }

  _statusAguardando(){
    _alterarBotao("Cancelar", Colors.red, (){_cancelarConsulta();


    });  setState(() {
      _imageni = "bck1/time.png";
    });
  }
  _criarConsulta() async {

    showDialog(
        context: context,
        builder: (contex){
          return AlertDialog(
            title: Text("Confirmar Consulta"),
            content: Text(" Deseja Confirmar a Consulta? "),
            contentPadding: EdgeInsets.all(16),
            actions: <Widget>[
              MaterialButton(
                child: Text("Cancelar", style: TextStyle(color: Colors.red),),
                onPressed: () => Navigator.pop(contex),
              ),
              MaterialButton(
                child: Text("Confirmar", style: TextStyle(color: Colors.green),),
                onPressed: (){
                  setState(() {
                    _imageni = "bck1/time.png";
                  });
                  //salvar requisicao
                  _salvarRequisicao();
                  //salvar requisicao ativa
                  Navigator.pop(contex);

                },
              )
            ],
          );
        }
    );

  }
  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  Requisicao requisicao = Requisicao();
  _salvarRequisicao() async {

    /*
    + requisicao
      + ID_REQUISICAO
        + destino (rua, endereco, latitude...)
        + passageiro (nome, email...)
        + motorista (nome, email..)
        + status (aguardando, a_caminho...finalizada)
    * */

    Usuario doc = await UsuarioFirebase.getDadosUsuarioLogado();


    requisicao.paciente = doc;
    requisicao.code = Uuid().v1().substring(0, 6);
    requisicao.status = StatusRequisicao.AGUARDANDO;

    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("requisicoes")
        .doc(requisicao.id)
        .set(requisicao.toMap())
    ;
    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = doc.idUsuario;
    dadosRequisicaoAtiva["code"] = requisicao.code;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;
    db.collection("requisicao_ativa")
        .doc(doc.idUsuario)
        .set(dadosRequisicaoAtiva);



  }
  _statusLeitura(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ChercherRoof(requisicao.code, requisicao.id)
    ));
  }
  _adicionarListenerRequisicaoAtiva()async{
    User  firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("requisicao_ativa")
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((snapshot){
      if(snapshot != null && snapshot.exists){
        Map<String, dynamic>? dados = snapshot.data();
        String? status = dados!["status"];
        _idRequisicao = dados["id_requisicao"];
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
      }else{
        _statusSemConsulta();
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
      appBar: AppBar(
        title: Text("Painel de Consulta"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){

              return itensMenu.map((String item){

                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );

              }).toList();

            },
          )
        ],
      ),
      body: Container(

          decoration: BoxDecoration(color: Colors.white, image: DecorationImage(
              image: AssetImage("bck1/back1000.png" ),
              fit: BoxFit.cover,

          )),
    child:
    SizedBox(
    height: MediaQuery.of(context).size.height,

          child: SingleChildScrollView(

              child: Column(children: [
            Padding(padding: EdgeInsets.fromLTRB(125, 24, 0, 6),
            child:

            Text("Crie sua ",  style: TextStyle(fontSize: 24, ))

              ,),
            Text("consulta abaixo!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.all(20)),
           //imageni
            Image.asset(_imageni),

            Padding(padding: EdgeInsets.fromLTRB(116, 6, 300, 32),)
            ,

               Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 5, 20, 5)
                    : EdgeInsets.all(5),
                child: MaterialButton(
                    child: Text(
                      _textoBotao,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: _corBotao,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: (){
                      _funcaoBotao();
                    }
                ),
              ),
            ],)
          )
    )

      ),
    );
  }
}
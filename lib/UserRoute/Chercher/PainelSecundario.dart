import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pidv1/Classes/StatusRequisicao.dart';
import 'package:pidv1/UserRoute/Consulta/GeralDoc.dart';
import 'dart:convert';


class PainelSecundario extends StatefulWidget {
  @override
  _PainelSecundarioState createState() => _PainelSecundarioState();
}

class _PainelSecundarioState extends State<PainelSecundario> {

  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");

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

 _adicionarListenerRequisicoes(){

    final stream = db.collection("requisicoes")
        .where("status", isEqualTo: StatusRequisicao.AGUARDANDO )
        .snapshots();

    stream.listen((dados){
      _controller.add( dados );
    });



  }

  @override
  void initState() {
    super.initState();

    //adiciona listener para recuperar requisições
    _adicionarListenerRequisicoes();

  }

  @override
  Widget build(BuildContext context) {

    var mensagemCarregando = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando requisições"),
          CircularProgressIndicator()
        ],
      ),
    );

    var mensagemNaoTemDados = Center(
      child: Text(
        "Não há nenhum médico disponível ",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Painel"),
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
      body:

      StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot){
            switch( snapshot.connectionState ){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return mensagemCarregando;
                break;
              case ConnectionState.active:
              case ConnectionState.done:

                if( snapshot.hasError ){
                  return Text("Erro ao carregar os dados!");
                }else {

                  QuerySnapshot? querySnapshot = snapshot.data;
                  if( querySnapshot!.docs.length == 0 ){
                    return mensagemNaoTemDados;
                  }else{

                    return
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 20, left: 10),
                          child:Text("Aqui estão os", style: TextStyle(fontSize: 18),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 0, left: 10),
                          child: Text("médicos disponíveis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                        ),
                        Padding(padding: EdgeInsets.only(top: 0, left: 10, bottom: 16),
                          child: Image.asset("bck1/list1.png", width: 230),
                        ),

                        Flexible(child:
                        ListView.separated(

                            itemCount: querySnapshot.docs.length,
                            separatorBuilder: (context, indice) => Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            itemBuilder: (context, indice){

                              List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                              DocumentSnapshot item = requisicoes[ indice ];

                              String idRequisicao = item["id"];
                              String code = item["code"];
                              String nomeDoutor = item["doutor"]["nome"];
                              String fotoDoutor = item["doutor"]["foto"];
                              String idDoutor = item["doutor"]["idUsuario"];
                              String describe = item["doutor"]["especializacao"];




                              return GestureDetector(

                                  onTap: (){

                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => GeralDoc(code, fotoDoutor, idDoutor, nomeDoutor, idRequisicao, describe)
                                    ));
                                  },
                                  child: Card(
                                      color: Colors.blueAccent,
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child:
                                        Column(

                                          children: [


                                            Row(children: [
                                              CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor: Colors.white70,
                                                  backgroundImage:
                                                   fotoDoutor!= null
                                                      ? NetworkImage(fotoDoutor)
                                                      : null
                                              ),

                                              Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                  Column(
                                                    children: [ Text(
                                                      nomeDoutor,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 6),),
                                                      Text(
                                                        describe,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,

                                                        ),
                                                      ),

                                                    ],
                                                  )


                                                ,),
                                              Icon(Icons.arrow_forward, color: Colors.white,)
                                            ],
                                            
                                            
                                            )
                                            ,
                                            

                                          ],

                                        )
                                        ,

                                      )
                                  )
                              );

                            }
                        )
                        )
                      ],
                    );


                  }

                }

                break;
            }
          }
      ),
    );
  }
}

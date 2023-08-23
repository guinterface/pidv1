import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../Classes/Avaliacao.dart';
class Notas extends StatefulWidget {
  const Notas({Key? key}) : super(key: key);

  @override
  _NotasState createState() => _NotasState();
}

class _NotasState extends State<Notas> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  final _controler2 = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<StreamController<QuerySnapshot>?> _adicionarListenerRequisicoes()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;

    final stream = db.collection("notas")
        .doc(usuarioLogado.uid)
        .collection("minhas_notas")
    .orderBy("data", descending: true)
        .snapshots();
    stream.listen((dados){_controler.add(dados);});

  }
  Future<StreamController<QuerySnapshot<Object?>>?> _adicionarListenerRequisicoes2()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;
    final stream = db.collection("avaliacoes")
        .doc(usuarioLogado.uid)
        .collection("meus_docs").
         orderBy("data",descending: false)
        .snapshots();
    stream.listen((dados){_controler2.add(dados);});


  }
  String _formatarData(String data){
    initializeDateFormatting("pt_BR",null);
    var formatador = DateFormat("d/MM/y");
    DateTime dataConvertida = DateTime.parse(data);
    String dataormada = formatador.format(dataConvertida);
    return dataormada;


  }


  @override
  void initState() {

    super.initState();
    _adicionarListenerRequisicoes();
    _adicionarListenerRequisicoes2();
  }


  @override

  Widget build(BuildContext context) {

    _exibirTelaCadastro(){

      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Adicionar anotação"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _tituloController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Exemplo: Tosse Seca"
                    ),
                  ),
                  TextField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                        labelText: "Descrição",
                        hintText: "Exemplo: Tosse durante 30 minutos, sem dor"
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar")
                ),
                MaterialButton(
                    onPressed: ()async{
                      String _idUsuarioLogado;
                      FirebaseAuth auth = FirebaseAuth.instance;
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      User usuarioLogado = await auth.currentUser!;
                      _idUsuarioLogado = usuarioLogado.uid;

                      Avaliacao avaliacao = Avaliacao();
                      avaliacao.descricao = _descricaoController.text;
                      avaliacao.titulo = _tituloController.text;
                      avaliacao.idUsuario = _idUsuarioLogado;
                      avaliacao.data = DateTime.now().toString();
                      db.collection("notas")
                          .doc( _idUsuarioLogado )
                          .collection("minhas_notas")
                          .doc(avaliacao.data)

                          .set( avaliacao.toMap() );


                      Navigator.pop(context);
                    },
                    child: Text("Salvar")
                )
              ],
            );
          }
      );

    }
    _exibirNota(String titulo, String descricao){

      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text(titulo, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(descricao, style: TextStyle(fontSize: 18,),),

                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Sair")
                ),

              ],
            );
          }
      );

    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Anotações"),),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /*
            Padding(padding:EdgeInsets.all(10),
              child: Text("Aqui estão os últimos", style: TextStyle(fontSize: 20),
              ),),
            Padding(padding:EdgeInsets.only(bottom: 10, left: 10),
              child: Text("diagnósticos dos seus médicos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),),
            Flexible(child:StreamBuilder<QuerySnapshot>

              (stream: _controler2.stream, builder:(context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(padding: EdgeInsets.all(12), child: Text(" Espere só um pouco...",),);
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if(snapshot.hasError){
                    return Text("Erro ao Carregar os Dados");
                  }else{
                    QuerySnapshot? querySnapshot = snapshot.data;
                    if(querySnapshot!.docs.length ==0){
                      return Padding(
                          padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                          child:
                          Column(
                            children: <Widget>[
                              Text("Você ainda não escreveu nenhum acontecimento sobre sua saúde,"
                                ,
                                style: TextStyle( fontSize: 18),


                              ) ,
                              Text(
                                " escreva um agora!",
                                style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold),
                              )],
                          )

                      );
                    }else {

                      return
                        SizedBox(
                          height: 160,

                          child: ListView.separated(
                            itemCount: querySnapshot.docs.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(24),

                            primary: false,
                            shrinkWrap: true,
                            separatorBuilder: (context, indice) => Divider( color:  Colors.white, indent: 16,),
                            itemBuilder: (context, indice){
                              List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                              DocumentSnapshot item = requisicoes[indice];
                              String titulo = item["titulo"];
                              String descricao = item["descricao"];
                              String data = item["data"];

                              return GestureDetector(

                                  onTap: (){_exibirNota(titulo, descricao);},
                                  child: Card(
                                      color: Colors.yellow,
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child:
                                        Column(

                                          children: [
                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                            Text(
                                              titulo,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )

                                              ,),
                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 16), child:
                                            Text(
                                              _formatarData(data),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )

                                              ,)

                                          ],

                                        )
                                        ,

                                      )
                                  )
                              );


                            },


                          ),
                        );
                      break;
                    }

                  }
              }



            }

              ,
            ),),

             */

            Padding(padding:EdgeInsets.only(top: 10, left: 12),
              child: Text("Escreva aqui o que aconteceu", style: TextStyle(fontSize: 18),
              ),),
            Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
              child: Text("na sua saúde hoje", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),),
            Padding(padding: EdgeInsets.all(12),
                child: AspectRatio(
                    aspectRatio: 18 / 9, // Adjust the aspect ratio as needed
                    child: Image.asset("bck1/nonk.png")
                )),

            Flexible(child:StreamBuilder<QuerySnapshot>

              (stream: _controler.stream, builder:(context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(padding: EdgeInsets.all(12), child: Text(" Espere só um pouco...",),);
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if(snapshot.hasError){
                    return Text("Erro ao Carregar os Dados");
                  }else{
                    QuerySnapshot? querySnapshot = snapshot.data;
                    if(querySnapshot!.docs.length ==0){
                      return Padding(
                          padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                          child:
                          Column(
                            children: <Widget>[
                              Text("Você ainda não escreveu nenhum acontecimento sobre sua saúde,"
                                  " escreva um agora!"
                                ,
                                style: TextStyle( fontSize: 16),


                              ) ,
                            ],
                          )

                      );
                    }else {

                      return
                        SizedBox(
                          height: 160,

                          child: ListView.separated(
                            itemCount: querySnapshot.docs.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(24),

                            primary: false,
                            shrinkWrap: true,
                            separatorBuilder: (context, indice) => Divider( color:  Colors.white, indent: 16,),
                            itemBuilder: (context, indice){
                              List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                              DocumentSnapshot item = requisicoes[indice];
                              String titulo = item["titulo"];
                              String descricao = item["descricao"];
                              String data = item["data"];

                              return GestureDetector(

                                  onTap: (){_exibirNota(titulo, descricao); },
                                  child: Card(
                                      color: Color(0xFF7ee500),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child:
                                        Column(

                                          children: [
                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                            Text(
                                              titulo,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )

                                              ,),
                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 16), child:
                                            Text(
                                              _formatarData(data),
                                              style: TextStyle(
                                                fontSize: 16,

                                              ),
                                            )

                                              ,)

                                          ],

                                        )
                                        ,

                                      )
                                  )
                              );


                            },


                          ),
                        );
                      break;
                    }

                  }
              }



            }

              ,
            ),  ),




            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 32), child:  FloatingActionButton(
                  onPressed: _exibirTelaCadastro,
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  child: Icon( Icons.add),),),
              ],
            ),





          ],
        ),
      ),

    );
  }
}

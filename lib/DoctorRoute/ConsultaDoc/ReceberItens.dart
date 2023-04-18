import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pidv1/Classes/Avalia%C3%A7%C3%A3o.dart';
import 'package:pidv1/Classes/Medicine.dart';
import 'package:url_launcher/url_launcher.dart';
class ReceberItens extends StatefulWidget {
  String _idUsuario;
ReceberItens(this._idUsuario);

  @override
  _ReceberItensState createState() => _ReceberItensState();
}

class _ReceberItensState extends State<ReceberItens> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _titulo2Controller = TextEditingController();
  TextEditingController _descricao2Controller = TextEditingController();
  TextEditingController _horarioController = TextEditingController();
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  final _controler2 = StreamController<QuerySnapshot>.broadcast();
  final _controler3 = StreamController<QuerySnapshot>.broadcast();
  final _controler4 = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<StreamController<QuerySnapshot>?> _adicionarListenerRequisicoes()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;


    final stream = db.collection("notas")
        .doc(widget._idUsuario)
        .collection("minhas_notas")
        .orderBy("data",descending: false)
        .snapshots();
    stream.listen((dados){_controler.add(dados);});

  }
  StreamController<QuerySnapshot>? _adicionarListenerRequisicoes2(){

    final stream = db.collection("docs")
    .doc(widget._idUsuario)
    .collection("meus_docs").
    orderBy("data",descending: false)
    .snapshots();
    stream.listen((dados){_controler2.add(dados);});


  }
  StreamController<QuerySnapshot>? _adicionarListenerRequisicoes3(){

    final stream = db.collection("medicines")
        .doc(widget._idUsuario)
        .collection("my_medicines").
    orderBy("data",descending: false)
        .snapshots();
    stream.listen((dados){_controler3.add(dados);});


  }
  StreamController<QuerySnapshot>? _adicionarListenerRequisicoes4(){

    final stream = db.collection("documentos")
        .doc(widget._idUsuario)
        .collection("meus_documentos").
    orderBy("data",descending: false)
        .snapshots();
    stream.listen((dados){_controler4.add(dados);});


  }
  String _formatarData(String data){
    initializeDateFormatting("pt_BR",null);
    var formatador = DateFormat("d/MM/y");
    DateTime dataConvertida = DateTime.parse(data);
    String dataormada = formatador.format(dataConvertida);
    return dataormada;


  }
  String _escolhaUsuario = "P";
  _exibirTela(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar Remédio"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titulo2Controller,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título",
                      hintText: "Exemplo: Tosse Seca"
                  ),
                ),
                Text("Categoria:"),


                RadioListTile(title: Text("Pílula/Cápsula"),value: "P", groupValue: _escolhaUsuario
                    , onChanged: (String? escolha){
                      setState(() {
                        _escolhaUsuario = escolha!;
                      });

                      (context as Element).reassemble();
                    } ),


                RadioListTile( title: Text("Líquido"),value: "L", groupValue: _escolhaUsuario
                    , onChanged: (String? escolha){
                      setState(() {
                        _escolhaUsuario = escolha!;
                      });

                      (context as Element).reassemble();
                    } ),


                RadioListTile(title: Text("Injeção"),value: "I", groupValue: _escolhaUsuario
                    , onChanged: (String? escolha){
                      setState(() {
                        _escolhaUsuario = escolha!;
                      });
                      (context as Element).reassemble();
                    } ),

                TextField(
                  controller: _descricao2Controller,
                  decoration: InputDecoration(
                      labelText: "Dias da semana:",
                      hintText: "Exemplo: Segunda a quinta"
                  ),
                ),
                TextField(
                  controller: _horarioController,
                  decoration: InputDecoration(
                      labelText: "Horário:",
                      hintText: "Exemplo: 18h"
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

                    Medicine medicine = Medicine();

                    medicine.titulo = _titulo2Controller.text;
                    medicine.idUsuario = widget._idUsuario;
                    medicine.horario = _horarioController.text;
                    medicine.diasdaSemana = _descricao2Controller.text;
                    medicine.categoria = _escolhaUsuario;
                    medicine.identidade = DateTime.now().toString();
                    db.collection("medicines")
                        .doc( widget._idUsuario )
                        .collection("my_medicines")
                        .doc(medicine.identidade)

                        .set( medicine.toMap() );


                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              )
            ],
          );
        }
    );

  }
  String _imagemBotao(String categ)  {
    if(categ =="P"){
      return "bck1/MedicinePill.png";
    }else if(categ == "I"){
      return "bck1/MedicineVaccine.png";
    }else{
      return "bck1/MedicineLiquid.png";
    }
  }
  _exibirUpload(String nome, String codigo, String extension)async{
    launch(codigo);
  }
  @override
  void initState() {

    super.initState();
    _adicionarListenerRequisicoes();
    _adicionarListenerRequisicoes2();
    _adicionarListenerRequisicoes3();
    _adicionarListenerRequisicoes4();
  }


  @override

  Widget build(BuildContext context) {

    _exibirTelaCadastro(){

      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Adicionar diagnóstico"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _tituloController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Exemplo: Febre"
                    ),
                  ),
                  TextField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                        labelText: "Recomendações",
                        hintText: "Ir ao Hospital"
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

                      Avaliacao avaliacao = Avaliacao();
                      avaliacao.descricao = _descricaoController.text;
                      avaliacao.titulo = _tituloController.text;
                      avaliacao.idUsuario = widget._idUsuario;
                      avaliacao.data = DateTime.now().toString();
                      db.collection("docs")
                          .doc( widget._idUsuario )
                          .collection("meus_docs")
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
                MaterialButton
                  (
                    onPressed: () => Navigator.pop(context),
                    child: Text("Sair")
                ),

              ],
            );
          }
      );

  }

  return Scaffold(
  appBar: AppBar(title: Text("Dados Paciente"),),
  body: Container(


  child: Center(
            child: SingleChildScrollView(

              child:
              SizedBox(
                height: 1500,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Padding(padding:EdgeInsets.all(10),
                      child: Text("Aqui estão os dados", style: TextStyle(fontSize: 16),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 10, left: 10),
                      child: Text("adicionados pelo paciente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
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
                                      Text("Seu paciente ainda não preencheu nenhum dado"
                                        ,
                                        style: TextStyle( fontSize: 14),


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
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    )

                                                      ,),
                                                    Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 16), child:
                                                    Text(
                                                      _formatarData(data),
                                                      style: TextStyle(
                                                          fontSize: 14,
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
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
                    Padding(padding:EdgeInsets.only(top: 10, left: 12),
                      child: Text("Abaixo estão os", style: TextStyle(fontSize: 18),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
                      child: Text("documentos de saúde do paciente:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
                    Expanded(child:  Flexible(child:StreamBuilder<QuerySnapshot>

                      (stream: _controler4.stream, builder:(context, snapshot){
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Seu paciente não adicionou nenhum documento"
                                        ,
                                        style: TextStyle( fontSize: 14),


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
                                      String codigo = item["url"];
                                      String data = item["data"];
                                      String extensao = item["diretorio"];

                                      return GestureDetector(

                                          onTap: (){_exibirUpload(titulo, codigo, extensao);},
                                          child: Card(
                                              color: Colors.yellow,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(36, 12, 36,12),
                                                child:
                                                Column(

                                                  children: [
                                                    Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                    Text(
                                                      titulo,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    )

                                                      ,),
                                                    Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 16), child:
                                                    Text(
                                                      _formatarData(data),
                                                      style: TextStyle(
                                                          fontSize: 14,
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
                    ),),),
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
                    Padding(padding:EdgeInsets.only(top: 10, left: 12),
                      child: Text("Aqui estão os medicicamentos,", style: TextStyle(fontSize: 18),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
                      child: Text("que o paciente utiliza", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
                    Flexible(child:StreamBuilder<QuerySnapshot>

                      (stream: _controler3.stream, builder:(context, snapshot){
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
                                      Text("Seu paciente não utiliza nenhum medicamento"

                                        ,
                                        style: TextStyle( fontSize: 14),


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
                                      String horario = item["horario"];
                                      String dia = item["diasdaSemana"];
                                      String categoria = item["categoria"];
                                      String deltar = item["identidade"];

                                      return GestureDetector(

                                          onTap: (){},
                                          child: Card(
                                              color: Colors.white70,
                                              child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child:
                                                Column(

                                                  children: [
                                                    Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                    Text(
                                                      titulo,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blueAccent
                                                      ),
                                                    )

                                                      ,),
                                                    Row(
                                                      children: [
                                                        Padding(padding: EdgeInsets.all(12),
                                                          child: Image.asset(_imagemBotao(categoria), height: 64,),

                                                        ),
                                                        Column(
                                                          children: [

                                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                            Text(
                                                              "Dias da Semana: $dia",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent
                                                              ),
                                                            )

                                                              ,),
                                                            Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                            Text(
                                                              "Horário: $horario",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent
                                                              ),
                                                            )

                                                              ,),
                                                          ],
                                                        ),


                                                      ],
                                                    )


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
                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),
                    Padding(padding:EdgeInsets.only(top: 10, left: 12),
                      child: Text("Aqui estão os diagnósticos do paciente,", style: TextStyle(fontSize: 18),
                      ),),
                    Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
                      child: Text("analise-os ou adicione outro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                      Text("Seu paciente ainda não recebeu nenhum diagnóstico"
                                        ,
                                        style: TextStyle( fontSize: 14),


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
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    )

                                                      ,),
                                                    Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 16), child:
                                                    Text(
                                                      _formatarData(data),
                                                      style: TextStyle(
                                                        fontSize: 14,

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

                    Padding(padding:EdgeInsets.only(bottom: 10, top: 10),

                    ),


                    Row(children: [
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 180, top: 32), child:  FloatingActionButton(
                            onPressed: _exibirTelaCadastro,
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            child: Icon( Icons.add_chart),),),
                          Padding(padding:EdgeInsets.only(top: 12, left: 152),
                            child: Text("Criar diagnóstico", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),),



                        ],
                      ),



                    ],),



                  ],

                ),
              )
            ),



        ),

      )
    );
  }
}

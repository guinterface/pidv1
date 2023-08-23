import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pidv1/Classes/Medicine.dart';
class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _horarioController = TextEditingController();
  List<String> selectedDays = [];
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  String _escolhaUsuario = "P";
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<StreamController<QuerySnapshot>?> _adicionarListenerRequisicoes()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;

    final stream = db.collection("medicines")
        .doc(usuarioLogado.uid)
        .collection("my_medicines")

        .snapshots();
    stream.listen((dados){_controler.add(dados);});

  }

String _imagemBotao(String categ)  {
    if(categ =="P"){
      return "bck1/MedicineLiquid.png";
    }else if(categ == "I"){
      return "bck1/MedicineVaccine.png";
    }else{
      return "bck1/MedicinePill.png";
    }
}
_removerAnuncio(String _idDoc)async{
  String _idUsuarioLogado;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User usuarioLogado = await auth.currentUser!;
  _idUsuarioLogado = usuarioLogado.uid;
  db.collection("medicines").
  doc(_idUsuarioLogado)
      .collection("my_medicines")
      .doc(_idDoc)
      .delete();

  }

  @override
  void initState() {

    super.initState();
    _adicionarListenerRequisicoes();

  }


  @override

  Widget build(BuildContext context) {

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
                    controller: _tituloController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Exemplo: Remédio 1"
                    ),
                  ),
                  /*
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
                  */

                  MultiSelectDialogField(
                    items: [
                      MultiSelectItem("Segunda", "Segunda"),
                      MultiSelectItem("Terça", "Terça"),
                      MultiSelectItem("Quarta", "Quarta"),
                      MultiSelectItem("Quinta", "Quinta"),
                      MultiSelectItem("Sexta", "Sexta"),
                      MultiSelectItem("Sábado", "Sábado"),
                      MultiSelectItem("Domingo", "Domingo"),


                      // Add other days of the week
                    ],
                    title: Text("Dias da semana:"),
                    buttonText: Text("Dias da Semana"),
                    onConfirm: (values) {
                      setState(() {
                        List<String> selectedStringValues = values.cast<String>();
                        selectedDays = selectedStringValues;

                      });
                    },
                  ),
                  SizedBox(height: 80, width: 50,
                    child: DateTimePicker(
                      type: DateTimePickerType.time,
                      initialValue: "12:00",
                      timeLabelText: "Hora",
                      onChanged: (val) => _horarioController.text = val,
                    ), ),
                  /*TextField(
                    controller: _horarioController,
                    decoration: InputDecoration(
                        labelText: "Horário:",
                        hintText: "Exemplo: 18h"
                    ),
                  )*/
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

                      Medicine medicine = Medicine();

                      medicine.titulo = _tituloController.text;
                      medicine.idUsuario = _idUsuarioLogado;
                      medicine.horario = [_horarioController.text];
                      medicine.diasdaSemana = selectedDays;
                      //medicine.categoria = _escolhaUsuario;
                      medicine.identidade = DateTime.now().toString();
                      db.collection("medicines")
                          .doc( _idUsuarioLogado )
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
      appBar: AppBar(title: Text("Medicamentos"),),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding:EdgeInsets.only(top: 10, left: 12),
              child: Text("Quais medicamentos você", style: TextStyle(fontSize: 18),
              ),),
            Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
              child: Text("utiliza atualmente?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),),
            Padding(padding: EdgeInsets.all(12),

              child:
              AspectRatio(
                aspectRatio: 15 / 9, // Adjust the aspect ratio as needed
                child: Image.asset("bck1/mdc.png")
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
                              Text("Você ainda não adicionou nenhum medicamento"

                                ,
                                style: TextStyle( fontSize: 16),


                              ) ,
                            ],
                          )

                      );
                    }else {

                      return
                        SizedBox(
                          height: 330,

                          child: ListView.separated(
                            itemCount: querySnapshot.docs.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(24),

                            primary: false,
                            shrinkWrap: true,
                            separatorBuilder: (context, indice) => Divider( color:  Colors.white, indent: 32,),
                            itemBuilder: (context, indice){
                              List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                              DocumentSnapshot item = requisicoes[indice];
                              String titulo = item["titulo"];
                              String descricao = item["descricao"];
                              String horario = "${item["horario"].join(', ')}";
                              String dia = "${item["diasdaSemana"].join(', ')}";
                              String categoria = item["categoria"];
                              String deltar = item["identidade"];

                              return GestureDetector(


                                  onTap: (){},
                                  child: Card(
                                      color: Colors.blue,
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
                                                  fontWeight: FontWeight.bold,
                                                color: Colors.white
                                              ),
                                            )

                                              ,),
                                               Row(
                                                 children: [
                                                   Padding(padding: EdgeInsets.all(12),
                                                     child: Image.asset(_imagemBotao(categoria), height: 36,),

                                                   ),
                                                   Column(
                                                     crossAxisAlignment: CrossAxisAlignment.center,
                                                     children: [

                                                       Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                           Container(width: 100, child:
                                                           Text(
                                                             "$dia",
                                                             softWrap: true,
                                                             style: TextStyle(
                                                                 fontSize: 12,
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Colors.white
                                                             ),
                                                           )
                                                             ,)


                                                         ,),
                                                       Padding(padding: EdgeInsets.only(left: 32, right: 32, ), child:
                                                       Text(
                                                         "Horário: $horario",
                                                         style: TextStyle(
                                                             fontSize: 12,
                                                             fontWeight: FontWeight.bold,
                                                             color: Colors.white
                                                         ),
                                                       )

                                                         ,),
                                                     ],
                                                   ),
                                                   GestureDetector(
                                                     child: Icon(Icons.delete, color: Colors.white, ) ,
                                                     onTap:  ()async{
                                                       await _removerAnuncio(deltar);
                                                     }
                                                   )

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






            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              GestureDetector(
                       onTap: _exibirTela,
              child: Container(

                width: 300,
                child: Text(
                    "Adicionar Medicamento",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),

                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(30), ),
              ),
            ),] )





          ],
        ),
      ),

    );
  }
}

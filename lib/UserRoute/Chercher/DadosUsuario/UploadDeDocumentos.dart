import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_support/file_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pidv1/Classes/Documento.dart';
import 'package:url_launcher/url_launcher.dart';
class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController _tituloController = TextEditingController();
  final _controler  = StreamController<QuerySnapshot>.broadcast();
  final _controler2 = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<StreamController<QuerySnapshot>?> _adicionarListenerRequisicoes()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;

    final stream = db.collection("documentos")
        .doc(usuarioLogado.uid)
        .collection("meus_documentos")
        .orderBy("data", descending: false)
        .snapshots();
    stream.listen((dados){_controler.add(dados);});

  }
  Future<StreamController<QuerySnapshot<Object?>>?> _adicionarListenerRequisicoes2()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User usuarioLogado = await auth.currentUser!;
    final stream = db.collection("docs")
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

  String _idUsuarioLogado = "";
  _criarUpload()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file;
    if (result != null) {

      file  = File(result.files.single.path!);
      _uploadFinal(file);


    } else {
      // Usuario cancelou
    }
  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await
    db.collection("usuarios")
        .doc( _idUsuarioLogado )
        .get();



  }
  String url ="";
  _recuperarURL(TaskSnapshot snapshot, File file) async {

    url = await snapshot.ref.getDownloadURL();

    Documento documento = Documento();
    documento.url = url ;
    documento.titulo = _tituloController.text;
    documento.data = DateTime.now().toString();
    documento.dreitorio = FileSupport().getFileExtension(file)!;
    db.collection("documentos")
        .doc( _idUsuarioLogado )
        .collection("meus_documentos")
        .doc(documento.data)

        .set( documento.toMap() );


  }
  Future _uploadFinal(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("uploads")
        .child(_idUsuarioLogado + DateTime.now().toString());
    UploadTask task = arquivo.putFile(file!);
    task.whenComplete(() => null).then((TaskSnapshot snapshot){
      _recuperarURL(snapshot, file);

    });

    //Recuperar url da imagem







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
  @override
  void initState() {

    super.initState();
    _recuperarDadosUsuario();
    _adicionarListenerRequisicoes();
    _adicionarListenerRequisicoes2();

  }
  _exibirTelaCadastro(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar Documento"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título",
                      hintText: "Exemplo: Meu Exame"
                  ),
                ),

              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              MaterialButton(
                  onPressed: ()async{
                    _criarUpload();

                    Navigator.pop(context);
                  },
                  child: Text("Upload")
              )
            ],
          );
        }
    );

  }

  @override

  Widget build(BuildContext context) {

    _exibirUpload(String nome, String codigo, String extension)async{
      launch(codigo);

    }

    return Scaffold(
      appBar: AppBar(title: Text("Documentos"),),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              Text("Você ainda não recebeu nenhum diagnóstico"
                                ,
                                style: TextStyle( fontSize: 18),


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

            Padding(padding:EdgeInsets.all(10),
              child: Text("Aqui estão os seus", style: TextStyle(fontSize: 20),
              ),),
            Padding(padding:EdgeInsets.only(bottom: 10, left: 10),
              child: Text("documentos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),),
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
                          padding: EdgeInsets.only(left: 64, top: 12, bottom: 16),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Você ainda não adicionou nenhum documento,"
                                ,
                                style: TextStyle( fontSize: 14),


                              ) ,
                              Text(
                                " adicione um agora!",
                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
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



            Row(),
            Padding(padding: EdgeInsets.only(left: 180, top: 32), child:  FloatingActionButton(
              onPressed: (()=>_exibirTelaCadastro()),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              child: Icon( Icons.upload_file),),),
            Padding(padding:EdgeInsets.only(top: 10, left: 145),
              child: Text("Upload de Arquivos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),),



          ],
        ),
      ),

    );
  }
}

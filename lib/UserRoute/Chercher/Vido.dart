
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidv1/UserRoute/Chercher/DadosUsuario/BloodPressure.dart';
import 'package:pidv1/UserRoute/Chercher/DadosUsuario/MeusDados.dart';
import 'dart:io';

import 'package:pidv1/UserRoute/Chercher/DadosUsuario/UploadDeDocumentos.dart';

class Vido extends StatefulWidget {
  @override
  _VidoState createState() => _VidoState();
}

class _VidoState extends State<Vido> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();
   File? _imagem;
  String _idUsuarioLogado = "";
  bool _subindoImagem = false;
  String _urlImagemRecuperada = "";


  Future _recuperarImagem(String origemImagem) async {
    XFile imagemSelecionada;
    final ImagePicker _picker = ImagePicker();
    if(origemImagem == "galeria"){
      imagemSelecionada = (await _picker.pickImage(source: ImageSource.gallery) )! ;
    }else{
      imagemSelecionada = (await _picker.pickImage(source: ImageSource.camera) )! ;
    }

    setState(() {

      _imagem =  File(imagemSelecionada.path);
      if( _imagem != null ){
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future _uploadImagem() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    UploadTask task = arquivo.putFile(_imagem!);

    //Controlar progresso do upload
    task.snapshotEvents.listen((TaskSnapshot storageEvent){

      if( storageEvent.state == TaskState.running ){
        setState(() {
          _subindoImagem = true;
        });
      }else if( storageEvent.state == TaskState.success ){
        setState(() {
          _subindoImagem = false;
        });
      }

    });

    //Recuperar url da imagem
    task.whenComplete(() => null).then((TaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });


  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });

  }

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

  _atualizarUrlImagemFirestore(String url){

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "foto" : url
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
      appBar: AppBar(title: Text("Perfil"),),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(3),
                  child: _subindoImagem
                      ? CircularProgressIndicator()
                      : Container(),
                ),
                Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30, top: 0), child:

                    Image.asset("bck1/bck17.png", width: 180, height: 225,)
                      ,),
                    Padding(padding: EdgeInsets.only(left: 40, top: 6), child:

                    CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                        _urlImagemRecuperada != null
                            ? NetworkImage(_urlImagemRecuperada)
                            : null
                    )
                      ,),

                  ],

                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recuperarImagem("camera");

                      },
                    ),
                    MaterialButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recuperarImagem("galeria");
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    onChanged: (texto){
                      _atualizarNomeFirestore();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 8, 8, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),

                ),
                 Padding(padding:
                 EdgeInsets.all(12),
                   child: MaterialButton(
                     padding: EdgeInsets.all(20),
                     color: Colors.blueAccent,
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(
                           builder: (context) => MeusDados()
                       ));
                     },
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: Row(
                       children: [
                       Icon(Icons.person, color: Colors.yellow,),
                         SizedBox(width: 20,),
                         Text("Dados Usuário", style: TextStyle(color: Colors.yellow),),


                         
                       ],
                     ),
                   ),
                 ),
                Padding(padding:
                EdgeInsets.all(12),
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.blueAccent,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Upload()
                      ));
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(Icons.folder, color: Colors.yellow,),
                        SizedBox(width: 20,),
                        Text("Documentos de Saúde", style: TextStyle(color: Colors.yellow),),



                      ],
                    ),
                  ),
                ),

                Padding(padding:
                EdgeInsets.all(12),
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.blueAccent,
                    onPressed: (){Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage()
                    ));},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.yellow,),
                        SizedBox(width: 20,),
                        Text("Batimentos Cardíacos", style: TextStyle(color: Colors.yellow),),



                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: MaterialButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _atualizarNomeFirestore();
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MeusDados extends StatefulWidget {
  @override
  _MeusDadosState createState() => _MeusDadosState();
}

class _MeusDadosState extends State<MeusDados> {


  TextEditingController _controllerpeso = TextEditingController();
  TextEditingController _doencas = TextEditingController();
  TextEditingController _altura = TextEditingController();
  String _controllerIMC = "";
  String _idUsuarioLogado = "";


  _atualizarFirestore(){


    int peso  = int.parse(_controllerpeso.text);
    String doenc = _doencas.text;
    int alt = int.parse(_altura.text);


    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nascimento" : dataatual.text,
      "peso" : peso,
      "doencas" : doenc,
      "altura" : alt
    };

    db.collection("usuarios")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );

  }


void _achaIMC(){

    if(_altura.text =="" && _controllerpeso.text == ""){
      setState(() {
        _controllerIMC = "Você ainda não adicionou seu peso ou altura";
      });
      return;
    }
    int altura = int.parse(_altura.text);
    int peso = int.parse(_controllerpeso.text);
     double _imc = peso!/(altura!/100);
     _imc = _imc/(altura!/100);
     if(_imc >=40){
       setState(() {
         _controllerIMC = "IMC de $_imc, Obesidade de Grau III";
       });
       return;
     }else{
       if(_imc >=35){
         setState(() {
           _controllerIMC = "IMC de $_imc, Obesidade de Grau II";
         });
         return;
       }else{
         if(_imc >=30){
           setState(() {
             _controllerIMC ="IMC de $_imc,Obesidade de Grau I";
           });
           return ;
         }else{
           if(_imc >=25){
             setState(() {
               _controllerIMC = "IMC de $_imc, Sobrepeso";
             });
             return ;
           }else{

             if(_imc >=18.5){
               setState(() {
                 _controllerIMC ="IMC de $_imc, Normal";
               });
               return ;
             }else{
               setState(() {
                 _controllerIMC = "IMC de $_imc, Magreza";
               });
               return ;
             }
           }
         }
       }
     }
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

   setState(() {
     dataatual.text = dados!["nascimento"];
     _controllerpeso.text = dados!['peso'].toString();
     _altura.text = dados['altura'].toString();
     _doencas.text = dados['doencas'];
   });





  }


  String _formatarData(String data){
    initializeDateFormatting("pt_BR", null);
    var formatador = DateFormat("d/MM/y");
    DateTime dataConvertida = DateTime.parse(data);
    String dataormada = formatador.format(dataConvertida);
    return dataormada;


  }
TextEditingController dataatual = TextEditingController();
  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _achaIMC();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Dados"),),

      body: Container(

        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding:EdgeInsets.only(top: 10, left: 12),
                  child: Text("Estes são os", style: TextStyle(fontSize: 22),
                  ),),
                Padding(padding:EdgeInsets.only(bottom: 16, left: 12),
                  child: Text("seus dados básicos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),),
                Image.asset("bck1/inf.png"),
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),
                    child: Text( "Data de nascimento:", style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 24, left: 12, top: 16),
                    child: Text( dataatual.text,style: TextStyle(fontSize: 20), )
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    color: Colors.yellow,

                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                      child:Text("Escolher Data", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) ,
                    ) ,
                    onPressed: (){
                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2025))
                  .then((value){
                    setState(() {
                      dataatual.text = _formatarData(value.toString());

                    });
                    _atualizarFirestore();
                  });

                }), 
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),
                    child: Text( "Qual seu peso (em kg)?",style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerpeso,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    onChanged: (texto){
                      _atualizarFirestore();
                      _achaIMC();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Ex: 85",
                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),
                    child: Text( "Qual sua altura (em cm)?", style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _altura,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    onChanged: (texto){
                      _atualizarFirestore();
                      _achaIMC();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Ex: 170",
                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),
                    child: Text( "Liste Aqui todas as doenças crônicas que possui:", style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _doencas,
                    autofocus: true,
                    style: TextStyle(fontSize: 20),
                    onChanged: (texto){
                      _atualizarFirestore();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Ex: Diabetes",
                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),
                    child: Text( "Resultado IMC:", style: TextStyle(),)
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 12, top: 16),

                    child:

                    Text( _controllerIMC, style: TextStyle(fontWeight: FontWeight.bold),)
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
                        //_atualizarNomeFirestore();
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
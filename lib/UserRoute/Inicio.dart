
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidv1/Classes/FirebaseUser.dart';
import 'package:pidv1/Classes/Usuario.dart';
import 'Cadastro.dart';
import 'Chercher/ChercherMain.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String mensagemErro = "";

  _verificaCadastro()async{
    Usuario usuario = await UsuarioFirebase.getDadosUsuarioLogado();
    if(usuario!=null){
      if(usuario.tipoUsuario == "doutor"){


      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChercherMain()),

        );

      }
    }
  }

  _validarCampos(){


    String _email = _controllerEmail.text;
    String _senha = _controllerSenha.text;
    if(_senha.isNotEmpty){
      if(_email.isNotEmpty){
        setState(() {
          mensagemErro = "";

        });
        Usuario usuario = Usuario();
        usuario.email = _email;
        usuario.senha = _senha;
        _logarUsuario(usuario);


      }else{ setState(() {
        mensagemErro = "Preencha o e-mail!";
      });}
    }else{ setState(() {
      mensagemErro = "Preencha a sua senha!";
    });}
  }
  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email, password: usuario.senha
    ).then((firebaseUser){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChercherMain()),

      );
    }).catchError((){

      setState(() {
        mensagemErro = " Algo deu errado, tente novamente! ";
      });

    }
    )
    ;


  }
  Future _verificaUsuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if(usuarioLogado != null){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChercherMain()

      ));


    }

  }
  @override
  void initState() {
    _verificaUsuarioLogado();
    // TODO: implement initState
    super.initState();
    _verificaCadastro();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login",),),
      body: Container(

        decoration: BoxDecoration(color: Colors.white, image: DecorationImage(
            image: AssetImage("bck1/bck1.png"),
            fit: BoxFit.cover
        )),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(

                  padding: EdgeInsets.only(top: 2, left: 12, ),
                  child:  Text("Olá,", style: TextStyle(fontSize: 22)),
                ) ,
                Padding(padding: EdgeInsets.only(top: 2, left: 8, right: 32, bottom: 32),
                    child:  Text("bem-vindo de volta!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                ) ,
                Padding(padding: EdgeInsets.only(top: 0),
                  child: TextField(autofocus: true,
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 2, 32, 16),
                        hintText: ("E-mail"),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
                TextField(obscureText : true,
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: ("Senha"),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                ),


                Padding(padding: EdgeInsets.only(top: 16, bottom: 10, left: 128),
                  child: MaterialButton(
                    child: Text("Entrar", style: TextStyle(color: Colors.white , fontSize: 20),),
                    color: Colors.blueAccent,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      _validarCampos();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text("CRIE UMA CONTA", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Cadastro()

                      )
                      );
                    },
                  ),
                ), Padding (
                  padding: EdgeInsets.only(top: 16),),

                Text(
                  mensagemErro, style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20
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
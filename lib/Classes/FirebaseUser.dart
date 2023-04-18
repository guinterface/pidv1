import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Usuario.dart';


class UsuarioFirebase {

  static Future<User> getUsuarioAtual() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser!;

  }

  static Future<Usuario> getDadosUsuarioLogado() async {

    User firebaseUser = await getUsuarioAtual();
    String idUsuario = firebaseUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("usuarios")
        .doc( idUsuario )
        .get();
     Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
     String tipoUsuario = dados!["tipoUsuario"];
     String email = dados["email"];
     String nome = dados["nome"];
     String foto = dados["foto"];
     String descricao = dados["descricao"];
     int peso = dados["peso"];
     String nascimento = dados["nascimento"];
     String doencas = dados["doencas"];
     int altura = dados["altura"];
     String especializacao = dados["especializacao"];




    Usuario usuario = Usuario();
    usuario.idUsuario = idUsuario;
    usuario.tipoUsuario = tipoUsuario;
    usuario.email = email;
    usuario.nome = nome;
    usuario.urlImagem = foto;
    usuario.descricao = descricao;
    usuario.peso = peso;
    usuario.altura = altura;
    usuario.doencas = doencas;
    usuario.nascimento = nascimento;
    usuario.especializacao = especializacao;

    return usuario;

  }

}
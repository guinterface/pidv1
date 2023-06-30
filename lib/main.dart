
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UserRoute/Inicio.dart';
Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      theme: ThemeData(
      primaryColor: Colors.blueAccent,

  ),
  debugShowCheckedModeBanner: false,
  home: Inicio(),


  ));}

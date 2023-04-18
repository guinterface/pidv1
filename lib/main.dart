
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UserRoute/Inicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      theme: ThemeData(
      primaryColor: Colors.blueAccent,
      accentColor: Colors.yellow
  ),
  debugShowCheckedModeBanner: false,
  home: Inicio(),


  ));}

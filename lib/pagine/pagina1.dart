import 'package:flutter/material.dart';
import '../login.dart';

class Pagina1 extends StatelessWidget{
  const Pagina1({super.key});

  @override

  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Login'),
    ),
    body: LoginPagina(),
  );




}
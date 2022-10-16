import 'package:flutter/material.dart';

import '../modulocertificato.dart';


class Pagina2 extends StatelessWidget{
  const Pagina2({super.key, required this.utente});
  final String utente;

  @override

  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Prepara certificato - Utente: '+utente),
    ),
    body: ModuloCertificato(utente: utente),
  );




}
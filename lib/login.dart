import 'package:flutter/material.dart';
import 'certificatopagina.dart';
import '/pagine/pagina2.dart';

class LoginPagina extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>LoginPaginaStato();
  }

class LoginPaginaStato extends State<LoginPagina>{
  late TextEditingController utente;
  late TextEditingController password;
  String statologin = '';
  @override
  void initState(){
    utente = TextEditingController();
    password = TextEditingController();
  }
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Form(key: formKey,
      child: Column(children:[
        spazio(),
        riga(utenteCampo()),
        spazio(),
        riga(passwordCampo()),
        spazio(),
        riga(bottoneLogin()),
        riga(statoLogin()),
      ]
      ));
  Widget utenteCampo() => TextFormField(

    controller: utente,
  decoration: InputDecoration(
  border: OutlineInputBorder(),
    labelText: 'Nome Utente'
  ),

  );
  Widget passwordCampo() => TextFormField(
    controller: password,
    obscureText: true,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
      labelText: 'Password'
    ),
  );
  Widget riga(Widget contenuto)  => Row(
      children: [
        spazioorizzontale(),
        Expanded(child: contenuto),
        spazioorizzontale()]);
  Widget spazioorizzontale() => Container(width: 20);
  Widget spazio() => Container(height: 20);
  Widget statoLogin() => Text(statologin, style: TextStyle(color: Colors.deepOrange));
  
  Widget bottoneLogin() => ElevatedButton(onPressed: () async {
    final List<String>? verificautente = await SpreadsheetApi.verificaUtente();
    if (verificautente != null){
      if (verificautente[0]! == utente.text && verificautente[1]! == password.text) {
        //String nomeutente = utente.text;
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Pagina2(utente: utente.text)),
      );} else { setState((){
        statologin = 'Nome utente o password non corretti';
      }); }
    }
  }, child: Text('Login'));

}
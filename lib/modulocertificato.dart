import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'certificatopagina.dart';
import 'downloadservice.dart';
import 'dart:io' as io;

class ModuloCertificato extends StatefulWidget {
  final String utente;
  const ModuloCertificato({super.key, required this.utente});

  @override
  State<StatefulWidget> createState() =>ModuloCertificatoStato();
}
class ModuloCertificatoStato extends State<ModuloCertificato>{
  late String utente;
  final String url = 'https://docs.google.com/spreadsheets/d/1CAdI5EvbXaXIX71rIijuxNKXQqnMcbfuiuBtbGp1O0Y/export?format=pdf&fitw=true&size=a4&gridlines=false&gid=0';
  Future<void> downloadFile() async {
    late DownloadService downloadService;
    if(kIsWeb) {downloadService =WebDownloadService();} else if (io.Platform.isWindows){downloadService = PcDownloadService();} else downloadService = MobileDownloadService();
    await downloadService.download(url: url);
  }

  final formKey = GlobalKey<FormState>();
  DateTime datascelta = DateTime.now();
  String? protocollo;
  late TextEditingController nomeecognome;
  late TextEditingController codicefiscale;
  late TextEditingController citta;
  late TextEditingController provincia;
  late TextEditingController istruttore;
  late TextEditingController numprotocollo;
  late TextEditingController numvalidazione;
  late bool aggiornamento;
  String scrittamedico = '';
  late TextEditingController medicocompetente;
  bool visibilemedico = false;
  String immaginevalidazione = '=image("https://drive.google.com/uc?export=download&id=1nle580DFdA32KpuARBHE6wU-bQBui3A9")';

  int indicecorso = 0;
  final List<String> tipocorso = [
    'BLS-D/PBLS-D',
    'ADDETTO AL PRIMO SOCCORSO AZIENDALE',
    'PHTC Esecutore'
  ];
  final List<String> dettaglicorso1 = [
    'Corso di Formazione Rianimazione Cardiopolmonare di Base',
    '',
    'Corso di PREHOSPITAL TRAUMA CARE'
  ];
  final List<String> dettaglicorso2 = [
    'per Adulto, Bambino e Lattante e Defibrillazione Precoce AED',
    '(ai sensi dell’art 37 comma 9 del D.Lgs. 81/08 e s.m.i. D.M. 388/03 e s.m.i., Gruppo B Medio Rischio',
    'Tecniche per la gestione, la valutazione e il trattamento'
  ];
  final List<String> dettaglicorso3 = [
    'ai sensi di: Legge 120 del 03/04/2001, DM 18/03/2011',
    '',
    'del politraumatizzato'
  ];
  final List<String> immaginecorso = [
    '=image("https://drive.google.com/uc?export=download&id=1lsXrhDTQZ3aD7z3x2jQM98GSF3NKM2ac")',
    '=image("https://drive.google.com/uc?export=download&id=1YtzTwZE6VXBo0rTzQtMeLXrtCR3KdJsw")',
    '=image("https://drive.google.com/uc?export=download&id=1lsXrhDTQZ3aD7z3x2jQM98GSF3NKM2ac")'
  ];
  final List<String> titolocorso = [
    'OPERATORE BLS-D/PBLS-D',
    'ADDETTO AL PRIMO SOCCORSO AZIENDALE',
    'ESECUTORE PHTC'
  ];

  final List<String> sottotitolocorso = [
    '',
    'Medio rischio',
    ''
  ];
  final List<int> duratacorso = [
    5,
    12,
    8
  ];
  final List<int> duratacorsoaggiornamento = [
    2,
    0,
    4
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      utente = widget.utente;
    });
    prendiprotocollo();
    inizializzaCampi();
  }
  Future prendiprotocollo() async {
    final protocolloultimodato = await SpreadsheetApi.prendicella(9, 38);
    int numprogressivo = int.parse(protocolloultimodato!.substring(7));
    String ultimecifreannoattuale = DateTime.now().year.toString().substring(2);
    setState(() {
      numprogressivo++;
      protocollo = ultimecifreannoattuale+'-A000'+numprogressivo.toString();
      numprotocollo = TextEditingController(text: protocollo);
    });
  }
  @override
  void didUpdateWidget(covariant ModuloCertificato oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    prendiprotocollo();
  }
  void inizializzaCampi(){
    nomeecognome = TextEditingController();
    codicefiscale = TextEditingController();
    citta = TextEditingController();
    provincia = TextEditingController();
    istruttore = TextEditingController();
    numvalidazione = TextEditingController();
    aggiornamento = false;
    medicocompetente = TextEditingController();
  }
  @override
  Widget build(BuildContext context) =>
      Form( key: formKey,
        child: Column(
          children: [
          tipoCertificatoCampo(),
          spazio(),
          riga(nomecognomeCampo()),
          spazio(),
          riga(codicefiscaleCampo()),
          spazio(),
          riga(luogo()),
          spazio(),
          riga(spaziodata()),
          spazio(),
          riga(spazioIstruttoreMedico()),
          spazio(),
          riga(spazioprotocollo()),
          spazio(),
          bottoneConferma(),
      ],
    ),
  );

  Widget tipoCertificatoCampo() => Row(
    children: [Expanded(child: Text('Corso: ',textAlign: TextAlign.right,),),

  Expanded( child:TextButton(style: ButtonStyle(alignment: Alignment.centerLeft), onPressed: () {setState(() {
    if (indicecorso <= tipocorso.length-2){
      indicecorso++;
    } else {indicecorso = 0;};
    indicecorso == 1 ? visibilemedico = true : visibilemedico = false;
  });},
    child: Text(tipocorso[indicecorso])
  )),
    Expanded(child: SwitchListTile(value: aggiornamento, title: Text('Aggiornamento'),onChanged: (value) => setState(() => aggiornamento = value))),
    ]);

  Widget nomecognomeCampo() => TextFormField(
    controller: nomeecognome,
    decoration: InputDecoration(
      labelText: 'Nome e cognome',
      border: OutlineInputBorder(),
      ),
      validator: (value) => value != null && value.isEmpty ? 'Inserire nome e cognome' : null,
    );

  Widget codicefiscaleCampo() => TextFormField(
    inputFormatters: [LengthLimitingTextInputFormatter(16)],
    controller: codicefiscale,
    decoration: InputDecoration(
      labelText: 'Codice fiscale',
      border: OutlineInputBorder(),
    ),
    validator: (value) => value != null && value.isEmpty ? 'Inserire codice fiscale' : null,
  );

  Widget luogo() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(flex: 5, child:TextFormField(
        controller: citta,
        decoration: InputDecoration(
          labelText: 'Città',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value != null && value.isEmpty ? 'Inserire una città' : null,
      ),),
      spazioorizzontale(),
      Expanded(
          child:TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(2)],
        controller: provincia,
        decoration: InputDecoration(
          labelText: 'Provincia',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value != null && value.isEmpty ? 'Inserire una provincia' : null,
      )),
    ],
  );
  Widget spazio() => Container(height: 20);
  Widget spazioorizzontale() => Container(width: 20);
  Widget spaziodata() => Row(
    children: [Expanded(child: Text('Data di conseguimento: ',textAlign: TextAlign.right,),),

      Expanded( child:
  TextButton(
    style: ButtonStyle(alignment: Alignment.centerLeft),
  onPressed: () async {
  DateTime? dataselezione = await scegliData();
  if (dataselezione == null) {return;};
  setState(() => datascelta = dataselezione);
},
child: Text(textAlign: TextAlign.left, datascelta.day.toString()+'/'+datascelta.month.toString()+'/'+datascelta.year.toString())),
  ),

    ]);


  Future scegliData() => showDatePicker(initialEntryMode: DatePickerEntryMode.calendar, context: context, initialDate: DateTime.now(), firstDate: DateTime.utc(2000), lastDate: DateTime.utc(2050));

  Widget spazioprotocollo() => Row(
    children: [
      Expanded(child: TextFormField(
        controller: numprotocollo,
        decoration: InputDecoration(
          labelText: 'Numero protocollo',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value != null && value.isEmpty ? 'Inserire numero protocollo' : null,
      )),
    spazioorizzontale(),
    Expanded(child: TextFormField(
      controller: numvalidazione,
      decoration: InputDecoration(
        labelText: 'Numero validazione',
        border: OutlineInputBorder(),
      ),
    ))
    ],
  );
  Widget spazioIstruttoreMedico() =>
      Row(
          children: [
            Expanded( child:TextFormField(
              controller: istruttore,
              decoration: InputDecoration(
                labelText: 'Istruttore',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value != null && value.isEmpty ? 'Inserire nome istruttore' : null,
            )),


      Visibility(

      visible: visibilemedico,
      child: Expanded(child:
      Row(children: [
        spazioorizzontale(),
        Expanded( child:TextFormField(
          controller: medicocompetente,
          decoration: InputDecoration(
            labelText: 'Medico competente',
            border: OutlineInputBorder(),
          ),
          validator: (value) {if(indicecorso == 1){value != null && value.isEmpty ? 'Inserire nome istruttore' : null;}} ,
        )),
      ]),))]
  );
  Widget riga(Widget contenuto)  => Row(
            children: [
            spazioorizzontale(),
            Expanded(child: contenuto),
            spazioorizzontale()]);

  Widget bottoneConferma() => ElevatedButton(
    onPressed: () async {
      final form = formKey.currentState!;
      final valido = form.validate();
      String cittadefinitiva = citta.text.toUpperCase();
      String datadefinitiva = datascelta.day.toString()+'/'+datascelta.month.toString()+'/'+datascelta.year.toString();
      String svoltosi = 'svoltosi il '+datadefinitiva+' a '+cittadefinitiva+' ('+provincia.text.toUpperCase()+')';
      String datainbasso = 'lì '+datadefinitiva;
      DateTime datascadenza = DateTime(datascelta.year+2, datascelta.month, datascelta.day);
      if (tipocorso[indicecorso]=='ADDETTO AL PRIMO SOCCORSO AZIENDALE') {setState(() {
        { datascadenza = DateTime(datascelta.year+3, datascelta.month, datascelta.day);}
      });}
      String aggiornamentoscritta = '';
      String scrittadurata = 'che ha frequentato il corso teorico - pratico della durata di '+duratacorso[indicecorso].toString()+' ore quale';
      if(aggiornamento) {setState(() {aggiornamentoscritta = 'AGGIORNAMENTO';
      scrittadurata = 'che ha frequentato il corso teorico - pratico della durata di '+duratacorsoaggiornamento[indicecorso].toString()+' ore quale';
      });};
      String scrittascadenza = 'Scadenza Certificato '+datascadenza!.day.toString()+'/'+datascadenza!.month.toString()+'/'+datascadenza!.year.toString();
      final List<String> dativalidazione = [
        '',
        '',
        '',
        '',
      ];
      if (numvalidazione.text.isNotEmpty){
        setState(() {
          dativalidazione[0] = 'VALIDAZIONE ACCREDITAMENTO';
          dativalidazione[1] = 'Arnas Civico Palermo U.O.C.';
          dativalidazione[2] = 'SUES Centrale Operativa 118 Palermo-Trapani';
          dativalidazione[3] = numvalidazione.text;
        });}
      if (indicecorso == 1) {
        setState(() {
          immaginevalidazione = '';
          scrittamedico = 'MEDICO COMPETENTE';
        });
      } else {
        setState(() {
          immaginevalidazione = '=image("https://drive.google.com/uc?export=download&id=1nle580DFdA32KpuARBHE6wU-bQBui3A9")';
          scrittamedico = '';
        });
      }

      final List<String> dati = [
        tipocorso[indicecorso], //0
        nomeecognome.text.toUpperCase(), //1
        codicefiscale.text.toUpperCase(), //2
        svoltosi, //3
        cittadefinitiva, //4
        datainbasso, //5
        dettaglicorso1[indicecorso],  //6
        dettaglicorso2[indicecorso], //7
        dettaglicorso3[indicecorso], //8
        immaginecorso[indicecorso], //9
        titolocorso[indicecorso], //10
        sottotitolocorso[indicecorso], //11
        scrittascadenza, //12
        aggiornamentoscritta, //13
        istruttore.text.toUpperCase(), //14
        scrittadurata, //15
        numprotocollo.text, //16
        dativalidazione[0], //17
        dativalidazione[1], //18
        dativalidazione[2], //19
        dativalidazione[3], //20
        scrittamedico, //21
        medicocompetente.text, //22
        immaginevalidazione, //23
        '=image("https://drive.google.com/uc?export=download&id=1xpnMlKZAIr_Mfy0V2mBI3ItHRbFl3kZ_")', //24
      ];

      if (valido) {
      await SpreadsheetApi.inserisci(dati);
      await downloadFile();
      prendiprotocollo();
      }
    },
    child: Text('Crea certificato'),
  );

}
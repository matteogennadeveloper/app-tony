import 'dart:io';
import 'package:gsheets/gsheets.dart';

import 'downloadservice.dart';

class SpreadsheetApi {

  static const _credenziali = r'''
  {
  "type": "service_account",
  "project_id": "certificato-364616",
  "private_key_id": "df94286151b131c71065f24523fd82069bdc50f8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7MB0HpkUe3fq2\nsptykcQdcugVE+2ZBL3PwWzkOZAoao6P7FtWMUTssduWEnW4wWTUPw0KekwfVh6p\nqkv4uGP50X5YMIIdOeB4+avgnmiiB1o1LYr6RtOf9mt84lY2zHb/YcPtJcSVCo8/\n70e3QeiIcwYLoaDbLyGfJJkHkBrRpTcB6Y8qJH16GTuQZNckSUwfrj1BhCepH6BM\nUxI2Mi/RwSOdvA2oEfvuNIVUQeKRQYdNn2W7vlASZOO3EKZV2QbRFYJHDvZjyG5b\n5LKyoaiOniRjtB1gZ8fNGK11xaqVfuGc95sd/hmpp3CVHldvSSpTbNtKbm10/gOw\nJ7Uo0t4zAgMBAAECggEAO7tpuBQtwGDTbVNnWVL8gu008+ztB8REkbRGfDmGL+94\n2KJyrvl/5gwHZ0cyu6cy9qu8DJjkC6felwOZxJ+Kf6CDMb8g9hSO9euuFjpWZ0Xz\nWj7TN3Q8ebIXsL1FB62NV4cqD1Xa+jhpZ9yCRQ9KFaimyDVmcCsFDpSOJKSuejEy\nKmpHcS6gBzSYkVVWAlMKiESYth4g2XmOrzGlebeWKEhRYzjhqDqJ0whpjT3t0jvx\nufeM08u4BQ267sW00XLCEP6KroWT/HwHo4xkITTWJdkUWDLgMuBACOrtE42E+Eh2\nxfsbsePpQuN1yj9tt+yzYqF6JKPfJb0NmQJtBYFgmQKBgQD+QRCVx3+DkK1PHSCj\nO+Zythl1xPhi/z+478pZo7kDSjxnlwwU27/tyXrUNRVLuTK9wYvHNSdYuAUjzPNV\nIrT8lufgbjsYZBtf81A1qUgwu/glZX/J4GZtBdP2JT4Sjkg/0uLDJywS0iWCIhtz\nFK7vsWTvGtC44u8oRoYhaed65QKBgQC8eShfTMGhWU+G36zySXInCtIPE5RpMKUo\nBcCRwDrqsqaPmKLD3an1ZaMymd+8/22lDqmKI9I0Hv69CBwfYFDip47eMf0/mNNI\ntMsWi8R9CpzDi952K4w+hg9hm67rHI6F5gRrfrb1qFue1g1ViztIVsk52tuclSPu\nqtCxbncrNwKBgQCIuCIb+If4Dk8zcJ1BSY+U9ZjhPEa4rTrtznvIEgMF4uByb8W+\nXaBqVGJpRBYsfuzrHu1z9IAw89tHsgjTKfOas+cCRyQd7I7P3L2v7VR1aE56hYbe\n3n0VeQHOpZ4oSjxNna/0ctb/U+N5g6+xBVlAaOq2rHu6P8WMqcespg8khQKBgQCS\nEPfn+82o5VWL+rfHQoKUnX80rgD8EPY+cU7P5oICuJf7e9jRIW6Bv9Zd9gD/MZph\nLF7ar25OdKMKD0n0SyoErsU7kNRrQF6m327xtzp9igb6SeEMBi33muA6znQexI/0\nV9KfGKJk+qifDddhr7kvFAt5qhM/ZBpn8rwwdqMmuwKBgAx6fdDVOflHcgkfYHEA\nlCs6krGujMBHydNJLRY1d4YtD+TNLfa6DRczj78S7kUfTZifxCAWkdTTfThtzXJk\n0G1DJhO+iQiy984Xne12tl0JEI86RDBDdvgcTHv01UHkS2UvR26XFWe7SmhNroR8\nllaype9OGAi8C6S6iApo62m2\n-----END PRIVATE KEY-----\n",
  "client_email": "admin-730@certificato-364616.iam.gserviceaccount.com",
  "client_id": "111357307199859698692",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/admin-730%40certificato-364616.iam.gserviceaccount.com"
}
  ''';
  static final _spreadsheetId = '1CAdI5EvbXaXIX71rIijuxNKXQqnMcbfuiuBtbGp1O0Y';
  static final _gsheets = GSheets(_credenziali);
  static Worksheet? _foglioCertificato;
  static Worksheet? _foglioUtenti;


  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _foglioCertificato = await spreadsheet.worksheetByTitle('Foglio1')!;
    _foglioUtenti = await spreadsheet.worksheetByTitle('Utenti')!;
  }
  static Future<List<String>?> verificaUtente() async {
    if (_foglioUtenti == null) return null;
    final valore = await _foglioUtenti!.values.row(2);
    return valore == null ? null : valore;
  }

  static Future<String?> prendicella(int colonna, int riga) async {
    if (_foglioCertificato == null) return null;
    final valore = await _foglioCertificato!.values.value(
        column: colonna, row: riga);
    return valore == null ? null : valore;
  }

  static Future inserisci(List<String> dati) async {
    if (_foglioCertificato == null) return;
    _foglioCertificato!.values.insertValue(dati[0], column: 3, row: 5);
    _foglioCertificato!.values.insertValue(dati[1], column: 3, row: 17);
    _foglioCertificato!.values.insertValue(dati[2], column: 3, row: 18);
    _foglioCertificato!.values.insertValue(dati[3], column: 3, row: 27);
    _foglioCertificato!.values.insertValue(dati[4], column: 3, row: 35);
    _foglioCertificato!.values.insertValue(dati[5], column: 3, row: 36);
    _foglioCertificato!.values.insertValue(dati[6], column: 3, row: 7);
    _foglioCertificato!.values.insertValue(dati[7], column: 3, row: 8);
    _foglioCertificato!.values.insertValue(dati[8], column: 3, row: 9);
    _foglioCertificato!.values.insertValue(dati[9], column: 1, row: 17);
    _foglioCertificato!.values.insertValue(dati[10], column: 3, row: 24);
    _foglioCertificato!.values.insertValue(dati[11], column: 3, row: 25);
    _foglioCertificato!.values.insertValue(dati[12], column: 3, row: 42);
    _foglioCertificato!.values.insertValue(dati[13], column: 3, row: 6);
    _foglioCertificato!.values.insertValue(dati[13], column: 3, row: 26);
    _foglioCertificato!.values.insertValue(dati[14], column: 7, row: 31);
    _foglioCertificato!.values.insertValue(dati[15], column: 3, row: 21);
    _foglioCertificato!.values.insertValue(dati[16], column: 9, row: 38);
    _foglioCertificato!.values.insertValue(dati[16], column: 9, row: 40);
    _foglioCertificato!.values.insertValue(dati[17], column: 3, row: 45);
    _foglioCertificato!.values.insertValue(dati[18], column: 3, row: 46);
    _foglioCertificato!.values.insertValue(dati[19], column: 3, row: 47);
    _foglioCertificato!.values.insertValue(dati[20], column: 6, row: 47);
    _foglioCertificato!.values.insertValue(dati[21], column: 7, row: 32);
    _foglioCertificato!.values.insertValue(dati[22], column: 7, row: 33);
    _foglioCertificato!.values.insertValue(dati[23], column: 1, row: 42);
    _foglioCertificato!.values.insertValue(dati[24], column: 1, row: 1);

  }
}

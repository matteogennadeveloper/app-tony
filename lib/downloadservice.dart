import 'package:flutter/foundation.dart';
import 'certificatopagina.dart';
import 'package:universal_html/html.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

abstract class DownloadService {
  Future<void> download({required String url});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async{
    window.open(url, "_blank");
  }
}
class PcDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {
    var dir = await getDownloadsDirectory();
    // gets the directory where we will download the file.


    // You should put the name you want for the file here.
    // Take in account the extension.
    String? nome = await SpreadsheetApi.prendicella(3, 17);
    String? corso = await SpreadsheetApi.prendicella(3, 5);
    String fileName = 'Certificato ' + nome! + ' - ' + corso!+'.pdf';

    // downloads the file
    Dio dio = Dio();
    await dio.download(url, "${dir!.path}/$fileName");

    // opens the file
    OpenFile.open("${dir!.path}/$fileName", type: 'application/pdf');
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<String?> getDownloadPath() async {
    io.Directory? directory;
    try {
      if (io.Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = io.Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      if (kDebugMode) {
        print("Cannot get download folder path");
      }
    }
    return directory?.path;
  }
     Future<void> download({required String url}) async {
      // requests permission for downloading the file
      bool hasPermission = await _requestWritePermission();
      if (!hasPermission) return;
      var dir = await getDownloadPath();
      // gets the directory where we will download the file.


      // You should put the name you want for the file here.
      // Take in account the extension.
      String? nome = await SpreadsheetApi.prendicella(3, 17);
      String? corso = await SpreadsheetApi.prendicella(3, 5);
      String fileName = 'Certificato '+nome!+' - '+corso!+'.pdf';

      // downloads the file
      Dio dio = Dio();
      await dio.download(url, "${dir!}/$fileName");

      // opens the file
      OpenFile.open("${dir!}/$fileName", type: 'application/pdf');
    }

    // requests storage permission
    Future<bool> _requestWritePermission() async {
      await Permission.storage.request();
      return await Permission.storage.request().isGranted;
    }
  }
import 'dart:convert';
import 'dart:io';
import 'package:packages_persistencia/models/anuncio.dart';
import 'package:path_provider/path_provider.dart';

class FilePersistence {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    File localFile = File('$localPath/anuncioFile.json');
    if (localFile.existsSync()) {
      return localFile;
    } else {
      return localFile.create(recursive: true);
    }
  }

  Future saveData(List<Anuncio> anuncios) async {
    final localFile = await _getLocalFile();
    List anuncioList = [];
    anuncios.forEach((anuncio) {
      anuncioList.add(anuncio.toMap());
    });
    String data = json.encode(anuncioList);
    return localFile.writeAsStringSync(data);
  }

  Future<List<Anuncio>?> getData() async {
    try {
      final localFile = await _getLocalFile();
      List anuncioList = [];
      List<Anuncio> anuncios = [];

      String content = await localFile.readAsString();
      anuncioList = json.decode(content);

      anuncioList.forEach((anuncio) {
        anuncios.add(Anuncio.fromMap(anuncio));
      });
      return anuncios;
    } catch (error) {
      print(error);
      return null;
    }
  }
}

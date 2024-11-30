import 'dart:io';

class Anuncio {
  int? id;
  late String titulo;
  late String descricao;
  late String preco;
  File? image;

  Anuncio(this.titulo, this.descricao, this.preco, this.image);

  Anuncio.fromMap(Map map) {
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.descricao = map['descricao'];
    this.preco = map['preco'];
    this.image = map['imagePath'] == '' ? File(map['imagePath']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'titulo': this.titulo,
      'descricao': this.descricao,
      'preco': this.preco,
      'imagePath': this.image != null ? this.image!.path : ''
    };
    return map;
  }

  @override
  String toString() {
    return "Anúncio(id: $id, título: $titulo, descrição: $descricao, preço: $preco, imagem: $image)";
  }
}

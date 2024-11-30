import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:packages_persistencia/models/anuncio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CadastroScreen extends StatefulWidget {
  Anuncio? anuncio;

  CadastroScreen({this.anuncio});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.anuncio != null) {
      setState(() {
        _tituloController.text = widget.anuncio!.titulo;
        _descricaoController.text = widget.anuncio!.descricao;
        _precoController.text = widget.anuncio!.preco;
        _image = widget.anuncio!.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Cadastro de Produtos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(width: 1, color: Colors.grey),
                        shape: BoxShape.circle,
                      ),
                      child: _image == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : ClipOval(
                              child: Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ),
                            )),
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      File image = File(pickedFile.path);
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String _localPath = directory.path;

                      String uniqueID = UniqueKey().toString();

                      final File savedImage =
                          await image.copy('$_localPath/image_$uniqueID.png');

                      setState(() {
                        _image = savedImage;
                      });
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 250, 214),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: TextFormField(
                          controller: _tituloController,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: "Informe o título do produto",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 28, 124, 77)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Preenchimento obrigatório.";
                            }
                          },
                        ),
                      ),
                      //const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 250, 214),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: TextFormField(
                          controller: _descricaoController,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: "Informe a descrição do produto",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 28, 124, 77)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Preenchimento obrigatório.";
                            }
                          },
                        ),
                      ),
                      //const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 250, 214),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: TextFormField(
                          controller: _precoController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: "Informe o preço do produto",
                            prefix: Text("R\$ "),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 28, 124, 77)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Preenchimento obrigatório.";
                            }
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              margin: const EdgeInsets.only(top: 10),
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    Anuncio newAnuncio = Anuncio(
                                        _tituloController.text,
                                        _descricaoController.text,
                                        _precoController.text,
                                        _image!);
                                    Navigator.pop(context, newAnuncio);
                                  }
                                },
                                child: const Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              margin: const EdgeInsets.only(top: 10),
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 207, 16, 16)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

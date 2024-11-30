import 'dart:io';
import 'package:packages_persistencia/file_persistence.dart';
import 'package:packages_persistencia/models/anuncio.dart';
import 'package:packages_persistencia/models/anuncio_helper.dart';
import 'package:packages_persistencia/screens/cadastro_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Anuncio> _lista = List.empty(growable: true);
  FilePersistence filePersistence = FilePersistence();
  AnuncioHelper _helper = AnuncioHelper();

  @override
  void initState() {
    super.initState();

    _helper.getAll().then((data) {
      setState(() {
        if (data != null) _lista = data;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    filePersistence.getData().then((value) {
      setState(() {
        if (value != null) _lista = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 199, 250, 214),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/lotus.png"), height: 30),
            SizedBox(width: 5),
            Text(
              "Fino Aroma Cosméticos",
              style: TextStyle(
                  color: Color.fromARGB(255, 28, 124, 77),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: _lista.length,
        itemBuilder: (context, position) {
          Anuncio item = _lista[position];
          return Dismissible(
            key: Key(_lista[position].titulo),
            background: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Colors.green,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    color: Colors.red,
                    child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete, color: Colors.white)),
                  ),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(253, 227, 229, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  item.image != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.file(
                            item.image!,
                            height: 120, // Define a altura da imagem
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(
                          height:
                              120, // Placeholder para o caso de não haver imagem
                          child: Icon(Icons.image_not_supported),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.titulo,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.descricao,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "R\$ ${item.preco}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 28, 124, 77),
                              fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor, // Cor do botão
                              shape: const CircleBorder(),
                              minimumSize: const Size(
                                  35, 35), // Faz o botão ser um círculo
                            ),
                            onPressed: () async {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.email,
                                                color: Colors.red),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              Anuncio anuncio =
                                                  _lista[position];

                                              final Uri uri = Uri(
                                                  scheme: 'mailto',
                                                  path:
                                                      'deborah.carrijo@estudante.ifgoiano.edu.br',
                                                  queryParameters: {
                                                    'subject': anuncio.titulo,
                                                    'body': 'Compre agora!'
                                                  });

                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                print(
                                                    "Erro ao enviar o anúncio.");
                                              }
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.sms,
                                                color: Colors.blue),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              Anuncio anuncio =
                                                  _lista[position];

                                              final Uri uri = Uri(
                                                  scheme: 'sms',
                                                  path: '+55649999-8888',
                                                  queryParameters: {
                                                    'body':
                                                        '${anuncio.titulo}, compre agora!'
                                                  });

                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                print(
                                                    "Erro ao enviar o anúncio.");
                                              }
                                            },
                                          ),
                                          ListTile(
                                            leading: const FaIcon(
                                                FontAwesomeIcons.whatsapp,
                                                color: Colors.green),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              Anuncio anuncio =
                                                  _lista[position];

                                              final Uri uri = Uri(
                                                  scheme: 'https',
                                                  host: 'wa.me',
                                                  path: '556499998888',
                                                  queryParameters: {
                                                    'text':
                                                        '${anuncio.titulo}, compre agora!',
                                                  });

                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                print(
                                                    "Erro ao enviar o anúncio.");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                              FocusScope.of(context).unfocus();
                            },
                            child: const Icon(Icons.share, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                Anuncio editedAnuncio = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroScreen(anuncio: item)),
                );
                var result = await _helper.editAnuncio(editedAnuncio);
                if (result != null) {
                  setState(() {
                    _lista.removeAt(position);
                    _lista.insert(position, editedAnuncio);
                    filePersistence.saveData(_lista);

                    const snackBar = SnackBar(
                        content: Text('Anúncio editado com sucesso!'),
                        backgroundColor: Colors.orange);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              } else if (direction == DismissDirection.endToStart) {
                var result = await _helper.deletAnuncio(item);
                if (result != null) {
                  setState(() {
                    _lista.removeAt(position);
                    filePersistence.saveData(_lista);

                    const snackBar = SnackBar(
                        content: Text('Anúncio apagado com sucesso!'),
                        backgroundColor: Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 243, 153, 161),
        foregroundColor: const Color.fromARGB(255, 28, 124, 77),
        label: const Text("Cadastrar \n produto"),
        icon: const Icon(Icons.add),
        onPressed: () async {
          try {
            Anuncio anuncio = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CadastroScreen()));

            Anuncio? savedAnuncio = await _helper.saveAnuncio(anuncio);
            if (savedAnuncio != null) {
              setState(() {
                _lista.add(anuncio);
                filePersistence.saveData(_lista);

                const snackBar = SnackBar(
                  content: Text('Anúncio criado com sucesso!'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }
          } catch (error) {
            print("Error: ${error.toString()}");
          }
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:activity_register/db/dboperation.dart';
import 'package:activity_register/models/users.dart';
import 'package:activity_register/pages/homepage.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  static const String ROUTE = '/addUser'; // ruta de esta pagina

  @override
  State<AddUser> createState() => _AddUserState();

  static Future<bool> _onWillPopScope(context) async {
    // esto es para avisar si quiere salir sin guardar datos
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Seguro desea salir sin guardar los datos?"),
        content: const Text("Datos sin guardar"),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Si")),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"))
        ],
      ),
    );
  }
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();

  final fotoController = TextEditingController();

  File? _image; // aqui se guarda la foto

  Future getImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera); //abrir camara
    if (image == null) return;
    final imageTemporary = File(image.path); //ubicacion de la foto

    setState(() {
      this._image = imageTemporary; // pasar la foto
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    _init(args);

    return WillPopScope(
        onWillPop: () async {
          final pop = await AddUser._onWillPopScope(context);
          return pop;
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Agregar")),
          body: Container(child: _buildForm(args)),
        ));
  }

  void _init(User user) {
    nombreController.text = user.nombre;
    fotoController.text = user.foto;
  }

  Widget _buildForm(User user) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              const SizedBox(height: 15),
              const Text("Imagen de peril"),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: () {
                  getImage(); // implementacion del metodo tomar foto
                },
                child: const Text("Tomar foto"),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Debe ingresar los datos";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Nombre", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (user.id != 0) {
                      // editar
                      user.nombre = nombreController.text;
                      user.foto = _image!.path;
                      OperationUser.update(user);
                    } else {
                      // guardar nuevo usuario
                      int id = Random().nextInt(1000) + 50;
                      OperationUser.insert(User(
                        id: id,
                        nombre: nombreController.text,
                        foto: _image!.path,
                        hasEvidencia: 0, // El cero representa falso
                      ));
                    }
                    Navigator.pop(context); // salir al guardar
                  }
                },
                child: const Text("Guardar datos del usuario"),
              ),
            ])));
  }
}

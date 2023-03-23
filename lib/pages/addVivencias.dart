import 'dart:io';
import 'dart:math';

import 'package:activity_register/models/arguments.dart';
import 'package:activity_register/models/users.dart';
import 'package:flutter/material.dart';
import 'package:activity_register/db/dboperation.dart';
import 'package:activity_register/models/vivencias.dart';
import 'package:activity_register/pages/vivencias.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AddVivencia extends StatefulWidget {
  static const String ROUTE = '/addvivencia';

  @override
  State<AddVivencia> createState() => _AddVivenciaState();

  static Future<bool> _onWillPopScope(context) async {
    // ventana para alertar que esta saliendo sin guardar los datos
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Segudo quieres salir sin guardar los datos?"),
        content: const Text("Datos sin guardar"),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Si')),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
        ],
      ),
    );
  }
}

class _AddVivenciaState extends State<AddVivencia> {
  final _formKey = GlobalKey<FormState>();

  final userController = TextEditingController();

  final tituloController = TextEditingController();

  final fechaController = TextEditingController();

  final descripcionController = TextEditingController();

  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemporary = File(image.path);
    print(image.path); //Borrar
    setState(() {
      this._image = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Arguments;

    BuildContext _context = context;
    _init(args.vivencias);

    return WillPopScope(
        onWillPop: () async {
          final pop = await AddVivencia._onWillPopScope(context);
          return pop;
        },
        child: Scaffold(
            appBar: AppBar(title: Text('Agregar')),
            body: Container(
                child: _buildForm(args.vivencias, args.user, _context))));
  }

  void _init(Vivencias vivencias) {
    tituloController.text = vivencias.titulo;
    fechaController.text = vivencias.fecha;
    descripcionController.text = vivencias.descripcion;
  }

  Widget _buildForm(Vivencias vivencias, User user, BuildContext _context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            const Text("Imagen de la vivencia"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                getImage();
              },
              child: const Text('Tomar foto'),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: tituloController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Debe ingresar un titulo";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Titulo", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: fechaController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese la Fecha";
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Fecha",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today_rounded)),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: _context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));

                fechaController.text =
                    DateFormat("dd-mm-yyyy").format(pickedDate!);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: descripcionController,
              maxLength: 1000,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Debe escribir los detalles";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Descripcion", border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (vivencias.id != 0) {
                      vivencias.titulo = tituloController.text;
                      vivencias.fecha = fechaController.text;
                      vivencias.descripcion = descripcionController.text;
                      vivencias.fecha = _image!.path;
                      OperationVivencias.update(vivencias);
                    } else {
                      int id = Random().nextInt(1000) + 50;
                      OperationVivencias.insert(Vivencias(
                          id: id,
                          user: user.id,
                          titulo: tituloController.text,
                          fecha: fechaController.text,
                          descripcion: descripcionController.text,
                          fotoVivencia: _image!.path
                          //  pathAudio: pathAudio
                          ));
                      user.hasEvidencia = 1;
                      OperationUser.update(user);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}

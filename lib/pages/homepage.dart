import 'dart:io';

import 'package:activity_register/models/vivencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:activity_register/pages/addUser.dart';
import '../db/dboperation.dart';
import '../models/users.dart';
import 'package:activity_register/pages/vivencias.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE = "/"; //Ruta de este Screen

  @override
  Widget build(BuildContext context) {
    return __User();
  }
}

class __User extends StatefulWidget {
  @override
  State<__User> createState() => __UserState();
}

class __UserState extends State<__User> {
  List<User> users = []; //Inicializando lista users
  @override
  void initState() {
    _LoadData(); //cargar la data para el screen
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: () {
            if (users.length > 0) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Ya Existe un usuario registrado'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Ok'))
                        ],
                      ));
            } else {
              Navigator.pushNamed(context, AddUser.ROUTE,
                  arguments: User.empty()); // Navegacion para agregar Usuario}
            }
          },
        ),
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: users.length, itemBuilder: (_, i) => _createItem(i)),
        ));
  }

  _LoadData() async {
    //metodo LoadData para buscar los datos en repositorio local
    List<User> auxUser = await OperationUser.users();
    // List<Vivencias> auxVivencias = await OperationVivencias.vivencias(auxUser);
    setState(() {
      users = auxUser;
    });
  }

  _createItem(int i) {
    return Dismissible(
        //elemento deslizable
        key: Key(i.toString()),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (direction) {
          OperationUser.delete(users[i]);
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 15),
            ListTile(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 5, color: Colors.cyan),
                  borderRadius: BorderRadius.circular(10)),
              title: Text(users[i].nombre),
              leading: Image.file(File(users[i].foto)),
              trailing: MaterialButton(
                onPressed: () {
                  // Boton para editar usuario
                  Navigator.pushNamed(context, AddUser.ROUTE,
                          arguments: users[i])
                      .then((value) => setState(() {
                            _LoadData();
                          }));
                },
                child: Icon(Icons.edit),
                padding: EdgeInsets.all(5),
              ),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(5)),
              title: const Text('Vivencias'),
              trailing: MaterialButton(
                // boton de vivencias de este usuario
                onPressed: () {
                  // El Cero Representa Falso
                  Navigator.pushNamed(context, ListVivencia.ROUTE,
                          arguments: users[i])
                      .then((value) => setState(() {
                            _LoadData();
                          }));
                  ;
                },
                padding: EdgeInsets.all(10),
                child: Icon(Icons.read_more),
              ),
            )
          ],
        ));
  }
}

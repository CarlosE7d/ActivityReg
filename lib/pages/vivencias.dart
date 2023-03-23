import 'package:activity_register/models/arguments.dart';
import 'package:activity_register/models/users.dart';
import 'package:activity_register/pages/addVivencias.dart';
import 'package:flutter/material.dart';
import 'package:activity_register/models/vivencias.dart';
import 'package:activity_register/db/dboperation.dart';
import 'package:activity_register/pages/homepage.dart';

class ListVivencia extends StatelessWidget {
  static const String ROUTE = "/vivencia";
  @override
  Widget build(BuildContext context) {
    return __MyVivencia();
  }
}

class __MyVivencia extends StatefulWidget {
  @override
  State<__MyVivencia> createState() => __MyListVivencia();
}

class __MyListVivencia extends State<__MyVivencia> {
  List<Vivencias> vivencia = [];
  User user = User.empty();
  @override
  void initState() {
    _LoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    user = args;
    // variable para almacenar id y poderlo pasar a nivel local
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Arguments aux = Arguments(user: args, vivencias: Vivencias.empty());
          //Boton Agregar Vivencia

          Navigator.pushNamed(context, AddVivencia.ROUTE, arguments: aux);
        },
      ),
      appBar: AppBar(
        title: const Text("Vivencias"),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: vivencia.length,
        itemBuilder: (_, i) => _createItem(i),
      )),
    );
  }

  _LoadData() async {
    List<Vivencias> auxVivencia = await OperationVivencias.vivencias();
    setState(() {
      vivencia = auxVivencia;
    });
  }

  _createItem(int i) {
    return Dismissible(
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
        OperationVivencias.delete(vivencia[i]);
      },
      child: ListTile(
        title: Text(vivencia[i].titulo),
        trailing: MaterialButton(
          onPressed: () {
            Arguments aux =
                Arguments(user: User.empty(), vivencias: vivencia[i]);
            Navigator.pushNamed(context, AddVivencia.ROUTE, arguments: aux)
                .then((value) => setState(() {
                      _LoadData();
                    }));
          },
          child: Icon(Icons.edit),
        ),
      ),
    );
  }
}

class User {
  int id;
  String nombre;
  String foto;
  int hasEvidencia;

  User(
      {required this.id,
      required this.nombre,
      required this.foto,
      required this.hasEvidencia});

  User.empty()
      : id = 0,
        nombre = "",
        foto = "",
        hasEvidencia = 0; // El cero Representa falso

  Map<String, dynamic> ToMap() {
    return {
      'id': id,
      'nombre': nombre,
      'foto': foto,
      'hasEvidencia': hasEvidencia
    };
  }
}

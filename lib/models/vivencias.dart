class Vivencias {
  int id;
  int user;
  String titulo;
  String fecha;
  String descripcion;
  String fotoVivencia;
  //String pathAudio;

  Vivencias({
    required this.id,
    required this.user,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.fotoVivencia,
    //    required this.pathAudio
  });

  Vivencias.empty()
      : id = 0,
        user = 0,
        titulo = '',
        fecha = '',
        descripcion = '',
        fotoVivencia = '';
  //  pathAudio = '';

  Map<String, dynamic> ToMap() {
    return {
      'id': id,
      'user': user,
      'titulo': titulo,
      'fecha': fecha,
      'descripcion': descripcion,
      'fotoVivencia': fotoVivencia,
      // 'pathAudio': pathAudio
    };
  }
}

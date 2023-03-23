import 'package:activity_register/models/vivencias.dart';
import 'package:activity_register/models/users.dart';

class Arguments {
  Vivencias vivencias;
  User user;

  Arguments({required this.user, required this.vivencias});

  Arguments.empty()
      : user = User.empty(),
        vivencias = Vivencias.empty();
}

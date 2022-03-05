class Usuario {
  String? _email;
  String? _name;
  String? _password;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nome': name,
      'email': email,
    };

    return map;
  }

  String get email {
    return _email!;
  }

  set email(value) {
    _email = value;
  }

  String get name {
    return _name!;
  }

  set name(value) {
    _name = value;
  }

  String get password {
    return _password!;
  }

  set password(value) {
    _password = value;
  }
}

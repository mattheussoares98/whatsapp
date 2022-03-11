class Usuario {
  String? _email;
  String? _name;
  String? _password;
  String? _imageUrl;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
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

  String get imageUrl {
    return _imageUrl!;
  }

  set imageUrl(value) {
    _imageUrl = value;
  }
}

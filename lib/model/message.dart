class Message {
  String? _message;
  String? _imageUrl;
  String? _tipo;
  String? _idLoggedUser;

  toMap() {
    Map<String, dynamic> map = {
      'message': message,
      'imageUrl': imageUrl,
      'tipo': tipo,
      'idLoggedUser': idLoggedUser,
    };

    return map;
  }

  String get message {
    return _message!;
  }

  set message(value) {
    _message = value;
  }

  String get idLoggedUser {
    return _idLoggedUser!;
  }

  set idLoggedUser(value) {
    _idLoggedUser = value;
  }

  String get imageUrl {
    return _imageUrl!;
  }

  set imageUrl(value) {
    _imageUrl = value;
  }

  String get tipo {
    return _tipo!;
  }

  set tipo(value) {
    _tipo = value;
  }
}

class Message {
  String? _message;
  String? _imageUrl;
  String? _tipe;
  String? _idLoggedUser;
  String? _dateTime;
  String? _idRecipientUser;
  String? _userName;

  toMap() {
    Map<String, dynamic> map = {
      'message': message,
      'imageUrl': imageUrl,
      'tipe': tipe,
      'idLoggedUser': idLoggedUser,
      'dateTime': dateTime,
      'idRecipientUser': idRecipientUser,
      'userName': userName,
    };

    return map;
  }

  String get message {
    return _message!;
  }

  set message(value) {
    _message = value;
  }

  String get userName {
    return _userName!;
  }

  set userName(value) {
    _userName = value;
  }

  String get idRecipientUser {
    return _idRecipientUser!;
  }

  set idRecipientUser(value) {
    _idRecipientUser = value;
  }

  String get idLoggedUser {
    return _idLoggedUser!;
  }

  set idLoggedUser(value) {
    _idLoggedUser = value;
  }

  String get dateTime {
    return _dateTime!;
  }

  set dateTime(value) {
    _dateTime = value;
  }

  String get imageUrl {
    return _imageUrl!;
  }

  set imageUrl(value) {
    _imageUrl = value;
  }

  String get tipe {
    return _tipe!;
  }

  set tipe(value) {
    _tipe = value;
  }
}

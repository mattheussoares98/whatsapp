class Conversations {
  String? _imageUrl;
  String? _message;
  String? _tipe;
  String? _dateTime;
  String? _idLoggedUser;
  String? _idRecipientUser;

  Conversations({
    required imageUrl,
    required message,
    required tipe,
    required dateTime,
    required idLoggedUser,
    required idRecipientUser,
  });

  String get imageUrl {
    return _imageUrl!;
  }

  set imageUrl(value) {
    _imageUrl = value;
  }

  String get message {
    return _message!;
  }

  set message(value) {
    _message = value;
  }

  String get tipe {
    return _tipe!;
  }

  set tipe(value) {
    _tipe = value;
  }

  String get dateTime {
    return _dateTime!;
  }

  set dateTime(value) {
    _dateTime = value;
  }

  String get idLoggedUser {
    return _idLoggedUser!;
  }

  set idLoggedUser(value) {
    _idLoggedUser = value;
  }

  String get idRecipientUser {
    return _idRecipientUser!;
  }

  set idRecipientUser(value) {
    _idRecipientUser = value;
  }
}

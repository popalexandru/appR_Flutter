class RegisterResponse {
  bool successful;
  bool wrongPassword;
  bool userAlreadyExists;
  bool fieldsAreBlank;

  RegisterResponse(
      this.successful, this.wrongPassword, this.userAlreadyExists, this.fieldsAreBlank);

  factory RegisterResponse.fromJson(dynamic json) {
    return RegisterResponse(
        json['successful'] as bool,
        json['wrongPassword'] as bool,
        json['userAlreadyExists'] as bool,
        json['fieldsAreBlank'] as bool);
  }
}

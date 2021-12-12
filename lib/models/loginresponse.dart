class LoginResponse {
  String token;
  bool successful;
  bool wrongPassword;
  bool userDoesntExist;

  LoginResponse(
      this.token, this.successful, this.wrongPassword, this.userDoesntExist);

  factory LoginResponse.fromJson(dynamic json) {
    return LoginResponse(json['token'] as String, json['successful'] as bool,
        json['wrongPassword'] as bool, json['userDoesntExist'] as bool);
  }
}

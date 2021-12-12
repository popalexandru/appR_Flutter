class User {
  String name;
  String surname;
  String email;
  String profileImageUrl;
  String password;
  String id;

  User(
      this.name, this.surname, this.email, this.profileImageUrl, this.password, this.id);

  factory User.fromJson(dynamic json) {
    return User(
        json['name'] as String,
        json['surname'] as String,
        json['email'] as String,
        json['profileImageUrl'] as String,
        json['password'] as String,
        json['id'] as String
    );
  }
}

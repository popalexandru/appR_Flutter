import 'package:appreservations/models/loginresponse.dart';
import 'package:appreservations/models/registerresponse.dart';
import 'package:http/http.dart';
import 'dart:convert';

class RegisterRequest{
  Uri url = Uri.parse('https://trackout.herokuapp.com/api/user/create');

  Future register(String name, String surname, String email, String password) async {

    try{
      Response response = await post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'surname': surname,
          'email': email,
          'password': password
        }),
      );

      print(response.body);

      return RegisterResponse.fromJson(jsonDecode(response.body));
    }
    catch(e){
      print('error $e');

      return null;
    }
  }
}
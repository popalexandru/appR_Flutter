import 'package:appreservations/models/loginresponse.dart';
import 'package:http/http.dart';
import 'dart:convert';

class LoginRequest{
  Uri url = Uri.parse('https://trackout.herokuapp.com/api/user/login');

  Future login(String email,String password) async {

    try{
      Response response = await post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password
        }),
      );

      print(response.body);

      return LoginResponse.fromJson(jsonDecode(response.body));
    }
    catch(e){
      print('error $e');

      return null;
    }
  }
}
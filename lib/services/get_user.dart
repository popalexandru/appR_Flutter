import 'package:appreservations/models/loginresponse.dart';
import 'package:appreservations/models/user.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRequest{
  final storage = new FlutterSecureStorage();


  Uri url = Uri.parse('https://trackout.herokuapp.com/api/get/user');

  Future<User?> getUser() async {
    String? token = await storage.read(key: 'jwt');

    try{
      Response response = await get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        }
      );

      return User.fromJson(jsonDecode(response.body));
    }catch(e){
      return null;
    }
  }
}
import 'dart:io';

import 'package:appreservations/models/businesssnippet.dart';
import 'package:appreservations/models/loginresponse.dart';
import 'package:appreservations/models/user.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BusinessSnippetRequest{
  final storage = new FlutterSecureStorage();

  Future<List<BusinessSnippet>?> getBusinessSnippets() async {
    String? token = await storage.read(key: 'jwt');

    Map<String, String> qParams ={
      'query': '',
      'page': '0',
      'pageSize': '5'
    };

    Uri url = Uri.parse('https://trackout.herokuapp.com/api/business/snippets/get?query=&page=0&pageSize=5');

    try{
      Response response = await get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        }
      );

      Iterable iterable = json.decode(response.body);

      List<BusinessSnippet> businesses = List<BusinessSnippet>.from(iterable.map((model) => BusinessSnippet.fromJson(model)));

      print(businesses);
    }catch(e){
      return null;
    }
  }

}
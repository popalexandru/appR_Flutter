import 'dart:async';

import 'package:appreservations/models/businesssnippet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';

enum ApiAction { Fetch }

class BusinessSnpBloc {
  /* local storage */
  final storage = new FlutterSecureStorage();

  /* pipe for data */
  final _businessesStreamController = StreamController<List<BusinessSnippet>>();

  StreamSink<List<BusinessSnippet>> get _snippetsSink =>
      _businessesStreamController.sink;

  Stream<List<BusinessSnippet>> get snippetsStream =>
      _businessesStreamController.stream;

  /* pipe for events */
  final _eventStreamController = StreamController<ApiAction>();

  StreamSink<ApiAction> get eventStreamSink => _eventStreamController.sink;

  Stream<ApiAction> get _eventStream => _eventStreamController.stream;

  BusinessSnpBloc() {
    _eventStream.listen((event) async {
      if (event == ApiAction.Fetch) {


        try {
          var snippets = await getBusinessSnippets();

          if(snippets != null) _snippetsSink.add(snippets);
        } on Exception catch (e) {
          _snippetsSink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<BusinessSnippet>?> getBusinessSnippets() async {
    String? token = await storage.read(key: 'jwt');

    Map<String, String> qParams = {'query': '', 'page': '0', 'pageSize': '5'};

    Uri url = Uri.parse(
        'https://trackout.herokuapp.com/api/business/snippets/get?query=&page=0&pageSize=5');

    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });

    Iterable iterable = json.decode(response.body);

    return List<BusinessSnippet>.from(
        iterable.map((model) => BusinessSnippet.fromJson(model)));
  }

  void dispose() {
    _businessesStreamController.close();
    _eventStreamController.close();
  }
}

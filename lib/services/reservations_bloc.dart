import 'dart:async';

import 'package:appreservations/models/businesssnippet.dart';
import 'package:appreservations/models/reservation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'home_bloc.dart';

class ReservationsBloc {
  /* local storage */
  final storage = new FlutterSecureStorage();

  /* pipe for data */
  final _businessesStreamController = StreamController<List<Reservation>>();

  StreamSink<List<Reservation>> get _snippetsSink =>
      _businessesStreamController.sink;

  Stream<List<Reservation>> get snippetsStream =>
      _businessesStreamController.stream;

  /* pipe for events */
  final _eventStreamController = StreamController<ApiAction>();

  StreamSink<ApiAction> get eventStreamSink => _eventStreamController.sink;

  Stream<ApiAction> get _eventStream => _eventStreamController.stream;

  ReservationsBloc() {
    _eventStream.listen((event) async {
      if (event == ApiAction.Fetch) {
        try {
          var snippets = await getReservations();

          print(snippets);

          if(snippets != null) _snippetsSink.add(snippets);
        } on Exception catch (e) {
          _snippetsSink.addError("Something went wrong");
        }
      }
    });
  }

  Future<List<Reservation>?> getReservations() async {
    String? token = await storage.read(key: 'jwt');

    Uri url = Uri.parse(
        'https://trackout.herokuapp.com/api/reservation/get/byuser');

    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });

    Iterable iterable = json.decode(response.body);

    print(response.body);

    return List<Reservation>.from(
        iterable.map((model) => Reservation.fromJson(model)));

/*    Map jsonList = json.decode(response.body);*/
  }

  void dispose() {
    _businessesStreamController.close();
    _eventStreamController.close();
  }
}

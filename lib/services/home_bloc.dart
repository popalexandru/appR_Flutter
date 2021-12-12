import 'dart:async';

import 'package:appreservations/models/businesssnippet.dart';
import 'package:appreservations/models/reservation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';

enum ApiAction { Fetch }

class HomeBloc {
  /* local storage */
  final storage = new FlutterSecureStorage();

  /* pipe for data */
  final _businessesStreamController = StreamController<List<BusinessSnippet>>();
  final _reservationStreamController = StreamController<List<Reservation>>();
  final _loadingStreamController = StreamController<bool>();


  StreamSink<List<BusinessSnippet>> get _snippetsSink =>
      _businessesStreamController.sink;
  Stream<List<BusinessSnippet>> get snippetsStream =>
      _businessesStreamController.stream;

  StreamSink<List<Reservation>> get _reservationsSink =>
      _reservationStreamController.sink;
  Stream<List<Reservation>> get reservationsStream =>
      _reservationStreamController.stream;

  Stream<bool> get loadingStream =>
      _loadingStreamController.stream;
  StreamSink<bool> get _loadingSink =>
      _loadingStreamController.sink;

  /* pipe for events */
  final _eventStreamController = StreamController<ApiAction>();
  final _reservationsStreamController = StreamController<ApiAction>();
  final _loadingEventStreamController = StreamController<bool>();


  StreamSink<ApiAction> get eventStreamSink => _eventStreamController.sink;
  Stream<ApiAction> get _eventStream => _eventStreamController.stream;

  StreamSink<ApiAction> get eventReservationsSink => _reservationsStreamController.sink;

  HomeBloc() {
    _eventStream.listen((event) async {
      if (event == ApiAction.Fetch) {
        _loadingSink.add(true);
        try {
          var snippets = await getBusinessSnippets();
          var reservations = await getReservations();

          if(snippets != null) _snippetsSink.add(snippets);
          if(reservations != null) _reservationsSink.add(reservations);

          _loadingSink.add(false);
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
        'https://trackout.herokuapp.com/api/business/snippets/get?query='+''+'&page=0&pageSize=5');

    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });

    Iterable iterable = json.decode(response.body);

    return List<BusinessSnippet>.from(
        iterable.map((model) => BusinessSnippet.fromJson(model)));
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
  }

  void dispose() {
    _businessesStreamController.close();
    _eventStreamController.close();
    _reservationsStreamController.close();
    _eventStreamController.close();
  }
}

import 'package:appreservations/pages/register.dart';
import 'package:appreservations/pages/reservation.dart';
import 'package:flutter/material.dart';
import 'package:appreservations/pages/home.dart';
import 'package:appreservations/pages/splash.dart';

import 'pages/login.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => AppHome(),
      '/reservation': (context) => Reservation(),
      '/login': (context) => Login(),
      '/register': (context) => Register()
    },
  ));
}

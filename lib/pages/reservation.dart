import 'package:flutter/material.dart';

class Reservation extends StatefulWidget {
  @override
  State<Reservation> createState() => _Reservation();
}

class _Reservation extends State<Reservation> {

  @override
  initState() {
    super.initState();
  }

  /*List<String> quotes = [
    "Maine",
    "Poimaine",
    "Vineri",
    "Salar 12300"
  ];

  Widget reservationTemplate(text){
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
      color: Colors.cyan,
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Rezervari'),
        centerTitle: false,
        backgroundColor: Colors.grey[850],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Reservation Screen',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

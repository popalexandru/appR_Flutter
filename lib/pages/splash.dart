import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _Loading();
}

class _Loading extends State<Loading> {

  final storage = new FlutterSecureStorage();

  void authenticate() async {


    String? token = await storage.read(key: 'jwt');

    Response response = await get(
        Uri.parse('https://trackout.herokuapp.com/api/user/authenticate'),
        headers: {
          'Authorization': 'Bearer $token'
        }
    );

    if(response.statusCode == 200){
      Navigator.pushReplacementNamed(context, '/home');
      print('Logged in');
    }else{
      Navigator.pushReplacementNamed(context, '/login');
      print('Not logged in');
    }
  }

  @override
  initState() {
    super.initState();

    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Center(
        child: SpinKitPianoWave(
          color: Colors.white,
        ),
      )
    );
  }

}

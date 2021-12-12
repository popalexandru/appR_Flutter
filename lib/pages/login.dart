import 'package:appreservations/models/loginresponse.dart';
import 'package:appreservations/shared/constants.dart';
import 'package:appreservations/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:appreservations/services/login_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _login = LoginRequest();
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _validator = Validator();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  int _loginButtonState = 0;

  @override
  initState() {
    super.initState();
  }

  void login(String email, String password) async {
    animateButton();
    dynamic response = await _login.login(email, password);

    if (response == null) {
      endAnimation();
      print('error');
      setState(() {
        error = "Something went wrong";
      });
    } else {
      LoginResponse loginResponse = response as LoginResponse;

      if (loginResponse.successful == true) {
        if (loginResponse.token.isNotEmpty) {
          await storage.write(key: 'jwt', value: loginResponse.token);

          Navigator.pushReplacementNamed(context, '/home');
          //endAnimation();
        }
      } else {
        if (loginResponse.userDoesntExist) {
          print('userDoesntExist');
          setState(() {
            error = "User doesn't exist";
          });
          endAnimation();
        } else if (loginResponse.wrongPassword) {
          print('wrongPassword');
          setState(() {
            error = "Password is wrong";
          });
          endAnimation();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Login"),
      centerTitle: true,
    ),
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => _validator.validateEmail(val!),
                decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  hintText: "Enter your email"
                ),
                onChanged: (val) {
                  setState(() {
                    email = val;
                    error = '';
                  });
                },
                style: const TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => _validator.validatePassword(val!),
                decoration: textInputDecoration.copyWith(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                    error = '';
                  });
                },
                style: const TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: setupButtonChild(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      login(email, password);
                    }
                  }),
              SizedBox(height: 20.0),
              Container(
                child: Text.rich(
                  TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: "Sign Up",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Sign Up click");
                                Navigator.pushNamed(context, '/register');
                              }),
                      ]),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget setupButtonChild() {
    if (_loginButtonState == 0) {
      return const Text(
        "Login",
        style: TextStyle(color: Colors.white),
      );
    } else if (_loginButtonState == 1) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _loginButtonState = 1;
    });
  }

  void endAnimation() {
    setState(() {
      _loginButtonState = 0;
    });
  }

  void buttonChecked() {
    setState(() {
      _loginButtonState = 2;
    });
  }
}

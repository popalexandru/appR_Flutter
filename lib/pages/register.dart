import 'package:appreservations/models/loginresponse.dart';
import 'package:appreservations/models/registerresponse.dart';
import 'package:appreservations/services/register_request.dart';
import 'package:appreservations/shared/constants.dart';
import 'package:appreservations/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:appreservations/services/login_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginRequest _login = LoginRequest();
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  final _registrator = RegisterRequest();
  int _loginButtonState = 0;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String error = '';

  @override
  initState() {
    super.initState();
  }

  void register(
      String name, String surname, String email, String password) async {
    animateButton();
    dynamic registerResponse =
        await _registrator.register(name, surname, email, password);

    if (registerResponse == null) {
      endAnimation();
      setState(() {
        error = "Something went wrong";
        endAnimation();
      });
    } else {
      RegisterResponse registerResp = registerResponse as RegisterResponse;

      if (registerResp.successful == false &&
          registerResp.fieldsAreBlank == true) {
        setState(() {
          error = "Fields are empty";
          endAnimation();
        });
      } else if (registerResp.successful == true &&
          registerResp.userAlreadyExists == true) {
        setState(() {
          error = "User already exists";
          endAnimation();
        });
      } else {
        buttonChecked();
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
              /* name text field */
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) => _validator.validateName(val!),
                decoration: textInputDecoration.copyWith(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                    error = '';
                  });
                },
                style: const TextStyle(color: Colors.grey),
              ),

              /* surname text field*/
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) => _validator.validateSurname(val!),
                decoration: textInputDecoration.copyWith(
                  labelText: 'Surname',
                  hintText: 'Enter your surname',
                ),
                onChanged: (val) {
                  setState(() {
                    surname = val;
                    error = '';
                  });
                },
                style: const TextStyle(color: Colors.grey),
              ),

              /* email text field */
              SizedBox(height: 10.0),
              TextFormField(
                validator: (val) => _validator.validateEmail(val!),
                decoration: textInputDecoration.copyWith(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                onChanged: (val) {
                  setState(() {
                    email = val;
                    error = '';
                  });
                },
                style: const TextStyle(color: Colors.grey),
              ),

              /* password text field */
              SizedBox(height: 10.0),
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
              SizedBox(height: 10.0),
              ElevatedButton(
                  child: setupButtonChild(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      register(name, surname, email, password);
                    }
                  }),
              SizedBox(height: 20.0),
              Container(
                child: Text.rich(
                  TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: "Sign In",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Sign In click");

                                Navigator.pushNamed(context, '/login');
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

    /*return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: Text('Login'),
          centerTitle: false,
          backgroundColor: Colors.grey[850]),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'User Name',
                        hintText: 'Enter valid mail id as abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.grey)
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your secure password',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.grey)
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;

                      login(email, password);
                    },
                    child: Text('Login'))
              ],
            ),
          )),
    );*/
  }

  Widget setupButtonChild() {
    if (_loginButtonState == 0) {
      return const Text(
        "Register",
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

  void clearError(){
    setState(() {
      error = '';
    });
  }
}

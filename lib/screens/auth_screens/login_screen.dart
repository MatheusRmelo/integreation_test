/*
Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signup_screen.dart';
import '../../model/idea_model.dart';
import '../home_screen.dart';
import '../../services/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthenticationService? authenticationService;
  const LoginScreen({Key? key, @required this.authenticationService})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthenticationService _authenticationService;

  @override
  void initState() {
    _authenticationService = widget.authenticationService!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      key: const ValueKey('emailLoginField'),
                      controller: _emailController,
                      cursorColor: Colors.green.shade900,
                      style: TextStyle(color: Colors.grey.shade400),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (s) =>
                          !s!.contains('@') ? 'invalid email' : null,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      key: const ValueKey('passwordLoginField'),
                      controller: _passwordController,
                      obscureText: true,
                      cursorColor: Colors.green.shade900,
                      style: TextStyle(color: Colors.grey.shade400),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (s) => s!.length <= 6
                          ? 'Password must be greater than 6'
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.green.shade800,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final result = await _authenticationService.loginUser(
                    _emailController.value.text.trim(),
                    _passwordController.value.text,
                  );
                  if (result!.substring(0, 7) == 'ERROR: ') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.substring(7),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'User Signed In',
                        ),
                        backgroundColor: Colors.green.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<HomeScreen>(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => IdeasModel(),
                          child: HomeScreen(
                            authenticationService: _authenticationService,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<SignUpScreen>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => IdeasModel(),
                    child: SignUpScreen(
                      authenticationService: _authenticationService,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

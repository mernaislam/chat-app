import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      if (_isLogin) {
        final _userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(_userCredentials);
      } else {
        final _userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(_userCredentials);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _enteredFirstName = newValue!;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _enteredLastName = newValue!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer
                            ),
                            child: Text(_isLogin ? 'Login' : 'Sign up'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an Account'
                                  : 'Already have an account?',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_gui/models/auth.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:provider/provider.dart';

enum AuthMode { Register, Login }

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<Map<String, dynamic>> _role = [
    {'value': 'admin', 'label': 'admin'},
    {'value': 'developer', 'label': 'developer'}
  ];
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'username': '',
    'password': '',
    'role': '',
  };
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error has occured'),
              content: Text('$message'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Uhh... ok'))
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['username'] as String,
          _authData['password'] as String,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).register(
            _authData['username'] as String,
            _authData['password'] as String,
            _authData['role']!);
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loginAsGuest() async {
    await Provider.of<Auth>(context, listen: false).login(
      'guest',
      'guest',
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Container(
        height: 320,
        constraints: BoxConstraints(minHeight: 320),
        width: _deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Username!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['username'] = value as String;
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  }),
              if (_authMode == AuthMode.Register)
                SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    initialValue: 'admin',
                    labelText: 'Select role [admin/developer]',
                    items: _role,
                    onSaved: (value) {
                      _authData['role'] = value as String;
                    }),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      )),
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              TextButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'} INSTEAD',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                onPressed: _switchAuthMode,
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              TextButton(
                child: Text('LOGIN AS GUEST INSTEAD',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                onPressed: loginAsGuest,
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

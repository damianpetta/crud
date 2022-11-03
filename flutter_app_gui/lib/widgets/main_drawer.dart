import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: (() {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            }))
      ]),
    );
  }
}

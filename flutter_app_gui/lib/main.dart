import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/auth.dart';
import './pages/auth_page.dart';
import './pages/home_page.dart';
import './models/students.dart';
import './pages/edit_student_page.dart';
import './widgets/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => Auth())),
          ChangeNotifierProxyProvider<Auth, StudentsList>(
            create: (ctx) => StudentsList(''),
            update: (ctx, auth, previousProducts) => StudentsList(auth.token),
          ),
        ],
        child: Consumer<Auth>(builder: (ctx, authData, _) {
          return MaterialApp(
            title: 'Crud Visualization',
            theme: ThemeData(
              textTheme: TextTheme(titleSmall: TextStyle(color: Colors.white)),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
                  .copyWith(
                      secondary: Color(0xFFA4161A), primary: Color(0xFFFF9800)),
            ),
            routes: {
              EditStudentPage.routeName: (ctx) => EditStudentPage(),
            },
            home: authData.isAuth
                ? HomePage()
                : FutureBuilder(
                    future: authData.tryAutologin(),
                    builder: ((context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Waiting()
                            : AuthenticationPage())),
          );
        }));
  }
}

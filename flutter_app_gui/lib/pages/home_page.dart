import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_student_page.dart';
import '../models/auth.dart';
import '../models/students.dart';
import '../widgets/list_of_students.dart';
import '../widgets/main_drawer.dart';
import '../pages/show_one_student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<StudentsList>(context, listen: false)
        .getStudentsFromServer()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserRole =
        Provider.of<Auth>(context, listen: false).userRole;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CrudApp (${currentUserRole})'),
          actions: [
            IconButton(
                onPressed: () {
                  if (currentUserRole == 'admin') {
                    Navigator.of(context).pushNamed(EditStudentPage.routeName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "You must be at least admin to add new student")));
                  }
                },
                icon: Icon(Icons.add)),
          ],
          bottom: TabBar(tabs: [
            Tab(
              text: 'All students',
            ),
            Tab(
              text: 'Show one Student',
            )
          ]),
        ),
        drawer: AppDrawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(children: [ListOfStudents(), ShowOneStudentPage()]),
      ),
    );
  }
}

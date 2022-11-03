import 'package:flutter/material.dart';
import 'package:flutter_app_gui/models/students.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../models/auth.dart';
import '../pages/edit_student_page.dart';

class StudentCard extends StatelessWidget {
  final Student currentStudent;
  StudentCard(this.currentStudent);
  @override
  Widget build(BuildContext context) {
    final currentUserRole = Provider.of<Auth>(context, listen: false).userRole;

    return Card(
      child: ListTile(
        leading: Text("ID: ${currentStudent.studentID}"),
        title: Center(
            child:
                Text("${currentStudent.firstName} ${currentStudent.lastName}")),
        subtitle: Center(child: Text("Age: ${currentStudent.age}")),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    if (currentUserRole == 'developer' ||
                        currentUserRole == 'admin') {
                      Navigator.of(context).pushNamed(EditStudentPage.routeName,
                          arguments: currentStudent.studentID);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "You must be at least admin or developer to edit student")));
                    }
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    if (currentUserRole == 'admin') {
                      Provider.of<StudentsList>(context, listen: false)
                          .deleteStudent(currentStudent.studentID);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "You must be at least admin to delete student")));
                    }
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}

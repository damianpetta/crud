import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../models/students.dart';
import './student_card.dart';

class ListOfStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Student> studentList = Provider.of<StudentsList>(context).students;

    return ListView.builder(
      itemBuilder: ((context, index) => StudentCard(studentList[index])),
      itemCount: studentList.length,
    );
  }
}

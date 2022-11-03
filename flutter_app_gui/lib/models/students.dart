import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './student.dart';
import './http_exception.dart';

class StudentsList with ChangeNotifier {
  final String token;
  StudentsList(this.token);
  List<Student> _students = [];

  List<Student> get students {
    return [..._students];
  }

  Future<void> getStudentsFromServer() async {
    final url = Uri.parse('http://10.0.2.2:8080/student/list');
    try {
      var response = await http.get(url);
      List<dynamic> recievedData = json.decode(response.body)['Data'];
      List<Student> studentsFromDB = [];
      recievedData.forEach((element) {
        Student newStudent = Student(
            studentID: element['ID'],
            firstName: element['firstname'],
            lastName: element['lastname'],
            age: element['age']);
        studentsFromDB.add(newStudent);
      });
      _students = studentsFromDB;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Student findById(int id) {
    return _students.firstWhere((student) => student.studentID == id);
  }

  Future<void> addStudent(Student newStudent) async {
    final url = Uri.parse('http://10.0.2.2:8080/student/add/');

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'firstname': newStudent.firstName,
            'lastname': newStudent.lastName,
            'age': newStudent.age,
          }));

      final newStudentData = Student(
        age: newStudent.age,
        firstName: newStudent.firstName,
        lastName: newStudent.lastName,
        studentID: json.decode(response.body)['Data']['ID'],
      );
      _students.add(newStudentData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> editStudent(Student newStudent) async {
    final studentIndex = _students
        .indexWhere((element) => element.studentID == newStudent.studentID);
    final url = Uri.parse(
        'http://10.0.2.2:8080/student/upd/' + newStudent.studentID.toString());

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'firstname': newStudent.firstName,
            'lastname': newStudent.lastName,
            'age': newStudent.age,
          }));

      _students[studentIndex] = newStudent;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteStudent(int studentID) async {
    final studentIndex =
        _students.indexWhere((element) => element.studentID == studentID);
    final url =
        Uri.parse('http://10.0.2.2:8080/student/del/' + studentID.toString());
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      _students.removeAt(studentIndex);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Student> getOneStudentFromServer(String studentID) async {
    final url = Uri.parse('http://10.0.2.2:8080/student/list/' + studentID);
    try {
      var response = await http.get(url);
      var recievedData = json.decode(response.body)['Data'];
      if (recievedData['ID'] <= 0) {
        throw HttpException('Could not find an student');
      }
      Student fetchedStudent = Student(
          studentID: recievedData['ID'],
          firstName: recievedData['firstname'],
          lastName: recievedData['lastname'],
          age: recievedData['age']);

      return fetchedStudent;
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/students.dart';
import '../models/student.dart';

class ShowOneStudentPage extends StatefulWidget {
  const ShowOneStudentPage({super.key});

  @override
  State<ShowOneStudentPage> createState() => _ShowOneStudentPageState();
}

class _ShowOneStudentPageState extends State<ShowOneStudentPage> {
  bool isLoading = false;
  int studentID = -1;
  late Student selectedStudent;
  final _studentIDController = TextEditingController();
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

  Future<void> _submitData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var fetchedStudent =
          await Provider.of<StudentsList>(context, listen: false)
              .getOneStudentFromServer(_studentIDController.text);
      setState(() {
        isLoading = false;
        selectedStudent = fetchedStudent;
        studentID = fetchedStudent.studentID;
      });
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text('An error occurred'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('ok'))
                ],
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(labelText: 'Student ID'),
            controller: _studentIDController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        if (isLoading && studentID != -1)
          Center(
            child: CircularProgressIndicator(),
          ),
        if (!isLoading && studentID != -1)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                child: Column(children: [
                  CircleAvatar(
                    child: Image.asset('assets/images/student.png'),
                    radius: 40,
                  ),
                  Text(
                    '${selectedStudent.firstName} ${selectedStudent.lastName}',
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'ID: ${selectedStudent.studentID} Age: ${selectedStudent.age}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  )
                ]),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
      ],
    );
  }
}

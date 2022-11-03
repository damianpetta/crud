import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/students.dart';
import 'package:provider/provider.dart';

class EditStudentPage extends StatefulWidget {
  static const routeName = '/edit_student';

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _form = GlobalKey<FormState>();

  // only for changing focus
  final _lastNameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();

  // I use that screen for both adding and deleting so I need a default empty student
  var _editedStudent =
      Student(studentID: 0, firstName: '', lastName: '', age: 0);
  bool isInit = true;
  Map _initValues = {
    'firstName': '',
    'lastName': '',
    'age': '',
  };
  // check if we are actually editing or adding an Student
  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final studentID = ModalRoute.of(context)!.settings.arguments as int;
        _editedStudent = Provider.of<StudentsList>(context, listen: false)
            .findById(studentID);
      }

      _initValues = {
        "firstName": _editedStudent.firstName,
        'lastName': _editedStudent.lastName,
        'age': _editedStudent.age.toString(),
      };
    }
    super.didChangeDependencies();
  }

  // memory clear (?)
  @override
  void dispose() {
    _ageFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  // saving form
  Future<void> _saveForm() async {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      if (_editedStudent.studentID != 0) {
        await Provider.of<StudentsList>(context, listen: false)
            .editStudent(_editedStudent);
        Navigator.of(context).pop();
      } else {
        await Provider.of<StudentsList>(context, listen: false)
            .addStudent(_editedStudent);
        Navigator.of(context).pop();
      }
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
                      },
                      child: Text('ok'))
                ],
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student"),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "First Name:"),
                  initialValue: _initValues['firstName'],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                  },
                  validator: (newValue) {
                    if (newValue!.isEmpty) {
                      return "Please provide a value";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedStudent = Student(
                        studentID: _editedStudent.studentID,
                        firstName: newValue!,
                        lastName: _editedStudent.lastName,
                        age: _editedStudent.age);
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: "Last Name:"),
                    initialValue: _initValues['lastName'],
                    focusNode: _lastNameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_ageFocusNode);
                    },
                    validator: (newValue) {
                      if (newValue!.isEmpty) {
                        return "Please provide a value";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedStudent = Student(
                          studentID: _editedStudent.studentID,
                          firstName: _editedStudent.firstName,
                          lastName: newValue!,
                          age: _editedStudent.age);
                    }),
                TextFormField(
                  decoration: InputDecoration(labelText: "Age:"),
                  initialValue: _initValues['age'].toString(),
                  focusNode: _ageFocusNode,
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  validator: (newValue) {
                    if (newValue!.isEmpty) {
                      return "Please provide a value";
                    }
                    if (double.tryParse(newValue) == null) {
                      return "Please enter a valid number";
                    }
                    if (double.parse(newValue) <= 0) {
                      return "Please enter a number greater than 0";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedStudent = Student(
                        studentID: _editedStudent.studentID,
                        firstName: _editedStudent.firstName,
                        lastName: _editedStudent.lastName,
                        age: int.parse(newValue!));
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ]),
            )),
      ),
    );
  }
}

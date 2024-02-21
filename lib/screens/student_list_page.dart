import 'dart:io';
import 'package:flutter/material.dart';
import 'package:db2/db/database_helper.dart';
import 'package:db2/model/student_model.dart';
import 'package:db2/screens/student_details_page.dart';
import 'package:db2/screens/add_student_page.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late DatabaseHelper databaseHelper;
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isSearching = false;
  Future<void> refreshStudentList() async {
    final studentList = await databaseHelper.getStudents();
    setState(() {
      students = studentList;
      filteredStudents = studentList;
    });
  }

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    refreshStudentList();
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students
            .where((student) =>
                student.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Student List')
            : TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  _filterStudents(query);
                },
                decoration: const InputDecoration(
                  hintText: 'Search student here',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredStudents = students;
                }
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: filteredStudents.isEmpty
          ? const Center(
              child: Text('No students found.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailPage(student: student),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              FileImage(File(student.profilePicturePath)),
                        ),
                        const SizedBox(height: 8.0),
                        Text(student.name),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddStudentPage(databaseHelper: databaseHelper),
            ),
          ).then((_) => refreshStudentList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

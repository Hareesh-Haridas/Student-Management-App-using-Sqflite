import 'package:flutter/material.dart';

import 'package:db2/screens/student_list_page.dart';

void main() {
  runApp(StudentRecordApp());
}

class StudentRecordApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Record App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListPage(),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:db2/model/student_model.dart';
import 'package:db2/db/database_helper.dart';

class AddStudentPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  AddStudentPage({required this.databaseHelper});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _rollnumberController = TextEditingController();
  String? _profilePicturePath;
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = img;
                  });
                  _profilePicturePath = image!.path;
                },
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _profilePicturePath != null
                      ? FileImage(File(_profilePicturePath!))
                      : null,
                  child: _profilePicturePath == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _rollnumberController,
                decoration: const InputDecoration(
                  labelText: 'Rollnumber',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your rollnumber';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final gender = _genderController.text;
                    final age = int.parse(_ageController.text);
                    final rollnumber = int.parse(_rollnumberController.text);
                    final student = Student(
                      id: 0,
                      name: name,
                      age: age,
                      gender: gender,
                      rollnumber: rollnumber,
                      profilePicturePath: _profilePicturePath ?? '',
                    );
                    widget.databaseHelper.insertStudent(student).then((id) {
                      if (id > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Student added successfully')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to add student')),
                        );
                      }
                    });
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

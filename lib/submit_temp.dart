import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectSubmissionScreen extends StatefulWidget {
  @override
  _ProjectSubmissionScreenState createState() => _ProjectSubmissionScreenState();
}

class _ProjectSubmissionScreenState extends State<ProjectSubmissionScreen> {
  final _titleController = TextEditingController();
  final _jobStateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personNeedController = TextEditingController();
  final _projectLengthController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companySizeController = TextEditingController();
  final _tagController = TextEditingController();

  final _projectsRef = FirebaseFirestore.instance.collection('projects');

  void _submitProject() async {
    try {
      await _projectsRef.add({
        'title': _titleController.text,
        'jobState': _jobStateController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'personNeed': _personNeedController.text,
        'projectLength': _projectLengthController.text,
        'companyName': _companyNameController.text,
        'companySize': _companySizeController.text,
        'tag': _tagController.text,
      });
      // Clear form fields and show success message
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Project'),
      ),
      body: Column(
        children: [
          // Text fields for all the fields
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: _jobStateController,
            decoration: InputDecoration(labelText: 'Job State'),
          ),
          // ...and so on for other fields
          ElevatedButton(
            onPressed: _submitProject,
            child: Text('Submit'),
          ),
          
        ],
      ),
    );
  }
}


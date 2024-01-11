import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ProjectStoreScreen extends StatefulWidget {
  final Project? existingProject; // Optional: Pass existing project for editing

  const ProjectStoreScreen({super.key, this.existingProject});

  @override
  State<ProjectStoreScreen> createState() => _ProjectStoreScreenState();
}

class _ProjectStoreScreenState extends State<ProjectStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _personNeedController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.ref().child('projects');

  @override
  void initState() {
    super.initState();
    if (widget.existingProject != null) {
      _titleController.text = widget.existingProject!.title;
      _descriptionController.text = widget.existingProject!.description;
      _locationController.text = widget.existingProject!.location;
      _personNeedController.text = widget.existingProject!.personNeed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingProject != null ? 'Edit Project' : 'Create Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _personNeedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of people needed'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitProject(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      personNeed: _personNeedController.text,
                    );
                  }
                },
                child: Text(widget.existingProject != null ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitProject({
    required String title,
    required String description,
    required String location,
    required String personNeed,
  }) async {
    // Create project object
    final project = Project(
      title: title,
      description: description,
      location: location,
      personNeed: personNeed,
    );

    if (widget.existingProject != null) {
      // Update existing project
        final generatedId = databaseReference.push().key!;
         await databaseReference.child(generatedId).set(project.toJson());
    } else {
      // Create new project
      await databaseReference.push().set(project.toJson());
    }

    // Back to previous screen
    Navigator.pop(context);
  }
}

class Project {
  final String title;
  final String description;
  final String location;
  final String personNeed;

  Project({
    required this.title,
    required this.description,
    required this.location,
    required this.personNeed,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'location': location,
    'personNeed': personNeed,
  };
}

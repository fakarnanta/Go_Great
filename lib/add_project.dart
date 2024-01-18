import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/final_add_project.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/splash.png',
                color: lightGrey,
                width: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Add Project',
                style: header,
              ),
              SizedBox(
                height: 43,
              ),
              AddProjectForm()
            ],
          ),
        ),
      )),
    );
  }
}

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({super.key});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _projectNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _messageController = TextEditingController();
  final _linkController = TextEditingController();
  final _personNeedController = TextEditingController();
  final _emailController = TextEditingController();

  final _projectsRef = FirebaseFirestore.instance.collection('projects');

  void _submitProject() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid; // Ensure user is not null

    try {
      await _projectsRef.add({
        'title': _projectNameController.text,
        'country': _countryController.text,
        'city': _cityController.text,
        'description': _descriptionController.text,
        'personNeed': _personNeedController.text,
        'message': _messageController.text,
        'groupLink': _linkController.text,
        'email': _emailController.text,
        'userId': userId,
      });

          if (mounted) {
      setState(() {
        // Clear form fields using each controller's clear() method
        _projectNameController.clear();
        _countryController.clear();
        _cityController.clear();
        _descriptionController.clear();
        _personNeedController.clear();
        _messageController.clear();
        _linkController.clear();
        _emailController.clear(); // Add if applicable
      });
    }

       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => (FinalAddProject())),
         );

      AnimatedSnackBar.material(
        'Project successfully added',
        type: AnimatedSnackBarType.success,
      ).show(context);

    } catch (error) {
      AnimatedSnackBar.material(
        'Cant add project, error occured.',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _projectNameController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Project Name',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _countryController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Country',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _cityController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'City',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _emailController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 133,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _descriptionController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _linkController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Link group for talent',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _personNeedController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'How much participant',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 10),
        Text('*Please write in etc. 10-20 format', style: GoogleFonts.raleway(fontSize:12, color: grey,)),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 1,
          height: 60,
          decoration: ShapeDecoration(
            color: Color(0xBFD3D3D3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset('assets/warning.svg'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Please check again. \nYou can edit later if there are any wrong.',
                style: GoogleFonts.openSans(fontSize: 13, color: grey),
              )
            ],
          ),
        ),
        SizedBox(
          height: 90,
        ),
        GestureDetector(
          onTap: () {
            _submitProject();
          },
          child: Center(
            child: Container(
              width: 150,
              height: 45,
              decoration: ShapeDecoration(
                color: Color(0xFF063F5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(64),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add Project',
                    style: GoogleFonts.raleway(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

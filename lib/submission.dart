import 'dart:io';
import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_great/final_apply.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';

class Submission extends StatefulWidget {
  Submission({
    this.companyName,
    this.companySize,
  });

  final String? companyName;
  final String? companySize;

  @override
  State<Submission> createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/splash.png',
                width: 80,
                color: lightGrey,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(18),
                width: MediaQuery.of(context).size.width * 1,
                height: 160,
                decoration: ShapeDecoration(
                  color: Color(0xFFFAD58C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submission',
                      style: header,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please submit your CV and portfolio. You may also include additional information if marked as optional.',
                      style: content,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              SubmissionForm(
                companyName: widget.companyName ?? '',
                companySize: widget.companySize ?? '',
              ),
            ],
          ),
        ),
      )),
    );
    ;
  }
}

class SubmissionForm extends StatefulWidget {
  SubmissionForm({
    this.companyName,
    this.companySize,
  });

  final String? companyName;
  final String? companySize;

  @override
  State<SubmissionForm> createState() => _SubmissionFormState();
}

class _SubmissionFormState extends State<SubmissionForm> {
  bool _isCVVisible = false;
  bool _isPortVisible = false;
  final TextEditingController _linkedincontroller = TextEditingController();
  String cvDownloadUrl = '';
  String cvFilename = '';
  String portfolioDownloadUrl = '';
  String portfolioFileName = '';
  bool uploadSuccessfull = false;
  int cvFileSize = 0;
  int portfolioFileSize = 0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Curriculum Vitae (CV)',
              style: TextStyle(
                color: Color(0xFF5F5F5F),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Color(0xFFC40202),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 7,
      ),
      GestureDetector(
        onTap: () {
          pickFile('CV');
          _toggleCVRowVisibility();
        },
        child: DottedBorder(
          padding: EdgeInsets.all(6),
          color: lightGrey,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Radius.circular(17),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 153,
                child: _isCVVisible
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LineIcon.file(),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cvFilename ?? 'No file selected',
                                  style: content,
                                ),
                                Text(
                                  formatBytes(cvFileSize, 2),
                                  style: GoogleFonts.raleway(
                                      fontSize: 10, color: primaryColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Drag or ',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'upload',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: ' project files',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
          ),
        ),
      ),
      SizedBox(
        height: 9,
      ),
      Text(
        'You may attach file under the size of 25 MB each.',
        style: GoogleFonts.openSans(fontSize: 12),
      ),
      SizedBox(
        height: 25,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Portofolio',
              style: TextStyle(
                color: Color(0xFF5F5F5F),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Color(0xFFC40202),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 7,
      ),
      GestureDetector(
        onTap: () {
          pickFile('Portfolio');
          _togglePortfolioRowVisibility();
        },
        child: DottedBorder(
          padding: EdgeInsets.all(6),
          color: lightGrey,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Radius.circular(17),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 153,
                child: _isPortVisible
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LineIcon.file(),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  portfolioFileName ?? 'No file selected',
                                  style: content,
                                ),
                                Text(
                                  formatBytes(portfolioFileSize, 2),
                                  style: GoogleFonts.raleway(
                                      fontSize: 10, color: primaryColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Drag or ',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'upload',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: ' project files',
                                style: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
          ),
        ),
      ),
      SizedBox(height: 5),
      Text(
        'You may attach file under the size of 25 MB each.',
        style: GoogleFonts.openSans(fontSize: 12),
      ),
      SizedBox(
        height: 24,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: MediaQuery.of(context).size.width * 1,
        height: 52,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
        child: TextFormField(
          controller: _linkedincontroller,
          style: content, // Customize text color // Hide password
          decoration: InputDecoration(
              labelText: 'Linkedin link',
              labelStyle: content, // Customize label color
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
      SizedBox(
        height: 44,
      ),
      Divider(
        thickness: 1,
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        'About The Company',
        style: GoogleFonts.sourceSans3(
            fontSize: 22, fontWeight: FontWeight.w700, color: primaryColor),
      ),
      SizedBox(
        height: 13,
      ),
      Row(
        children: [
          Container(
            width: 69,
            height: 69,
            decoration: ShapeDecoration(
              color: Color(0xFF063F5C),
              shape: OvalBorder(),
            ),
            child: Center(child: Image.asset('assets/business.png')),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.companyName ?? 'Unknown',
                style: GoogleFonts.openSans(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                widget.companySize ?? 'Unknown',
                style: GoogleFonts.openSans(
                    fontSize: 13, fontWeight: FontWeight.w400),
              )
            ],
          )
        ],
      ),
      SizedBox(
        height: 50,
      ),
      GestureDetector(
        onTap: () {
          submitProject();
        },
        child: Center(
          child: Container(
            width: 232,
            height: 52,
            decoration: ShapeDecoration(
              color: Color(0xBFF7AD1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(179),
              ),
            ),
            child: Center(
                child: Text(
              'Submit',
              style: GoogleFonts.raleway(fontSize: 18),
            )),
          ),
        ),
      )
    ]);
  }

  Future<void> pickFile(String fileType) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print('No user logged in.');
    return;
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    PlatformFile file = result.files.first;
    String fileName = file.name;
    int fileSize = file.size;

    try {
      // Upload file to Firebase Storage
      String downloadURL = await uploadFile(file.path!, fileName);

      setState(() {
        uploadSuccessfull = true;
        if (fileType == 'CV') {
          cvDownloadUrl = downloadURL;
          cvFilename = fileName;
          cvFileSize = fileSize;
          _isCVVisible = true;
        } else if (fileType == 'Portfolio') {
          portfolioDownloadUrl = downloadURL;
          portfolioFileName = fileName;
          portfolioFileSize = fileSize;
          _isPortVisible = true;
        }
      });

      // Update the 'users' collection in Firestore with CV or Portfolio data
      if (fileType == 'CV') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'cvUrl': downloadURL,
          'fileName': fileName,
        });
      } else if (fileType == 'Portfolio') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'portfolioDownloadUrl': downloadURL,
          'portfolioFileName': fileName,
        });
      }

      print('$fileType Upload Successful: $downloadURL');
    } catch (e) {
      print('Error uploading file or updating Firestore: $e');
    }
  } else {
    print('File selection canceled');
  }
}


  Future<String> uploadFile(String filePath, String fileName) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(File(filePath));
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  void submitProject() async {
  // Get the current user's information
  final currentUser = FirebaseAuth.instance.currentUser;

  if (cvDownloadUrl == '' || portfolioDownloadUrl == '') {
    AnimatedSnackBar.material(
      'Please fill all form first',
      type: AnimatedSnackBarType.info,
    ).show(context);
  } else {
    if (currentUser == null) {
      AnimatedSnackBar.material(
        'No user is logged in. Please log in first.',
        type: AnimatedSnackBarType.error,
      ).show(context);
      return;
    }


    final userId = currentUser.uid;
    final userEmail = currentUser.email ?? 'Unknown Email';
    final userName = currentUser.displayName ?? 'Unknown User';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) 
          .collection('applications') 
          .add({
        'userId': userId,
        'userEmail': userEmail,
        'userName': userName,
        'cvDownloadUrl': cvDownloadUrl,
        'portfolioDownloadUrl': portfolioDownloadUrl,
        'appliedAt': FieldValue.serverTimestamp(),
      });



      _showCustomDialog(context);
    } catch (e) {

      print("Error submitting application: $e");
      AnimatedSnackBar.material(
        'Error submitting application. Please try again later.',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }
}


  void _showFileMissingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('File Missing'),
        content: Text('Please choose both CV and Portfolio files.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 21),
              width: 311.04,
              height: 220.51,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are You Sure?',
                    style: header,
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Sometimes we make mistakes, please double-check to avoid wrong data.',
                    style: content,
                  ),
                  SizedBox(height: 26,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                           Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 101.72,
                          height: 43,
                          decoration: ShapeDecoration(
                            color: Color(0xFFC40202),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(179),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.raleway(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                           AnimatedSnackBar.material(
                          'Project successfully apply',
                          type: AnimatedSnackBarType.success,
                        ).show(context);

                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => FinalApply(),
                      ),
                    );
                        },
                        child: Container(
                          width: 101.72,
                          height: 43,
                          decoration: ShapeDecoration(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(179),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Yes, Sure',
                              style: GoogleFonts.raleway(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  void _toggleCVRowVisibility() {
    setState(() {
      _isCVVisible = !_isCVVisible;
    });
  }

  void _togglePortfolioRowVisibility() {
    setState(() {
      _isPortVisible = !_isPortVisible;
    });
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}

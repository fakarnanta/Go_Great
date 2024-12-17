import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationEdit extends StatelessWidget {
  const EducationEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: Column(
              children: [
                EducationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EducationForm extends StatefulWidget {
  const EducationForm({super.key});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  List<EducationEntry> educationEntries = [EducationEntry()];

  Future<void> _saveAllEducationToFirestore() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      for (var entry in educationEntries) {
        if (!entry.validate()) {
          AnimatedSnackBar.material(
            'Please fill all form',
            type: AnimatedSnackBarType.info,
          ).show(context);
          return;
        }
      }

      for (var entry in educationEntries) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('education')
            .add(entry.toMap());
      }

      AnimatedSnackBar.material(
        'Education added successfully',
        type: AnimatedSnackBarType.success,
      ).show(context);
      setState(() {
        educationEntries = [EducationEntry()];
      });
    } catch (e) {
      print("Error saving education: $e");
      AnimatedSnackBar.material(
        'Unexpected error try again later',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...educationEntries.asMap().entries.map((entry) {
              int index = entry.key;
              EducationEntry educationEntry = entry.value;
              return Column(
                children: [
                  educationEntry.buildForm(),
                  if (index != 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            educationEntries.removeAt(index);
                          });
                        },
                      ),
                    ),
                ],
              );
            }).toList(),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  educationEntries.add(EducationEntry());
                });
              },
              icon: const Icon(
                Icons.add,
                color: primaryColor,
              ),
              label: Text(
                'Add Another School',
                style: content,
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            GestureDetector(
              onTap: () {
                _saveAllEducationToFirestore();
              },
              child: Container(
                width: 150,
                height: 52,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                    child: Text(
                  'Update bio!',
                  style: GoogleFonts.raleway(fontSize: 14, color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationEntry {
  final TextEditingController universityController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  String? startMonth;
  String? startYear;
  String? endMonth;
  String? endYear;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> years =
      List.generate(70, (index) => (1980 + index).toString());

  bool validate() {
    return universityController.text.isNotEmpty &&
        majorController.text.isNotEmpty &&
        startMonth != null &&
        startYear != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'university': universityController.text.trim(),
      'major': majorController.text.trim(),
      'schoolPeriod': {
        'start': '$startMonth $startYear',
        'end': endMonth == null ? 'Present' : '$endMonth $endYear',
      },
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: subHeader,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: universityController,
            decoration: InputDecoration(
              labelText: 'School Name',
              labelStyle: content,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Major
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: majorController,
            decoration: InputDecoration(
              labelText: 'Major',
              labelStyle: content,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text('School Period',
            style: GoogleFonts.raleway(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Start Month',
                    style: content,
                  ),
                  value: startMonth,
                  items: months
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: content,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    startMonth = value;
                  },
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Start Year',
                    style: content,
                  ),
                  value: startYear,
                  items: years
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: content,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    startYear = value;
                  },
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'End Month',
                    style: content,
                  ),
                  value: endMonth,
                  items: months
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: content,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    endMonth = value;
                  },
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'End Year',
                    style: content,
                  ),
                  value: endYear,
                  items: years
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: content,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    endYear = value;
                  },
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

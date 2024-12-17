import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_great/constant.dart';

class WorkExperienceEdit extends StatelessWidget {
  const WorkExperienceEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: Column(
              children: [
                WorkExperienceForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkExperienceForm extends StatefulWidget {
  const WorkExperienceForm({super.key});

  @override
  State<WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  List<WorkExperienceEntry> workExperienceEntries = [WorkExperienceEntry()];

  Future<void> _saveAllWorkExperienceToFirestore() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      for (var entry in workExperienceEntries) {
        if (!entry.validate()) {
          AnimatedSnackBar.material(
            'Please fill all fields',
            type: AnimatedSnackBarType.info,
          ).show(context);
          return;
        }
      }

      for (var entry in workExperienceEntries) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('workExperience')
            .add(entry.toMap());
      }

      AnimatedSnackBar.material(
        'Work experience added successfully',
        type: AnimatedSnackBarType.success,
      ).show(context);
      setState(() {
        workExperienceEntries = [WorkExperienceEntry()];
      });
    } catch (e) {
      print("Error saving work experience: $e");
      AnimatedSnackBar.material(
        'Unexpected error, try again later',
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
            ...workExperienceEntries.asMap().entries.map((entry) {
              int index = entry.key;
              WorkExperienceEntry workExperienceEntry = entry.value;
              return Column(
                children: [
                  workExperienceEntry.buildForm(),
                  if (index != 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            workExperienceEntries.removeAt(index);
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
                  workExperienceEntries.add(WorkExperienceEntry());
                });
              },
              icon: const Icon(
                Icons.add,
                color: primaryColor,
              ),
              label: Text(
                'Add Another Job',
                style: content,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _saveAllWorkExperienceToFirestore();
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

class WorkExperienceEntry {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
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
    return companyController.text.isNotEmpty &&
        positionController.text.isNotEmpty &&
        startMonth != null &&
        startYear != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'company': companyController.text.trim(),
      'position': positionController.text.trim(),
      'workPeriod': {
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
          'Work Experience',
          style: subHeader,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: companyController,
            decoration: InputDecoration(
              labelText: 'Company Name',
              labelStyle: content,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: positionController,
            decoration: InputDecoration(
              labelText: 'Position',
              labelStyle: content,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Work Period',
            style: GoogleFonts.raleway(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDropdown('Start Month', months, startMonth, (value) {
                startMonth = value;
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildDropdown('Start Year', years, startYear, (value) {
                startYear = value;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildDropdown('End Month', months, endMonth, (value) {
                endMonth = value;
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildDropdown('End Year', years, endYear, (value) {
                endYear = value;
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildDropdown(String hint, List<String> items, String? value,
      void Function(String?) onChanged) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xBF5F5F5F), width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: content,
          ),
          value: value,
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: content,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

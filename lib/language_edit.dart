import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageEdit extends StatelessWidget {
  const LanguageEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: Column(
              children: [
                LanguageForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageForm extends StatefulWidget {
  const LanguageForm({super.key});

  @override
  State<LanguageForm> createState() => _LanguageFormState();
}

class _LanguageFormState extends State<LanguageForm> {
  List<LanguageEntry> languageEntries = [LanguageEntry()];

  Future<void> _saveLanguagesToFirestore() async {
    try {
      // Get user ID from Firebase Auth
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        AnimatedSnackBar.material(
          'User not logged in',
          type: AnimatedSnackBarType.info,
        ).show(context);
        return;
      }

      // Validate all entries
      for (var entry in languageEntries) {
        if (!entry.validate()) {
          AnimatedSnackBar.material(
            'Please complete all fields before saving!',
            type: AnimatedSnackBarType.info,
          ).show(context);
          return;
        }
      }

      // Save each language entry to Firestore
      for (var entry in languageEntries) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('languages')
            .add({
          'language': entry.language,
          'proficiency': entry.proficiency,
        });
      }

      AnimatedSnackBar.material(
        'Languages saved successfully!',
        type: AnimatedSnackBarType.success,
      ).show(context);

      setState(() {
        languageEntries = [LanguageEntry()];
      });
    } catch (e) {
      print('Error saving languages: $e');
      AnimatedSnackBar.material(
        'An error occurred. Please try again later.',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ...languageEntries.asMap().entries.map((entry) {
            int index = entry.key;
            LanguageEntry languageEntry = entry.value;
            return Column(
              children: [
                languageEntry.buildForm(),
                if (index != 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          languageEntries.removeAt(index);
                        });
                      },
                    ),
                  ),
              ],
            );
          }).toList(),
          const SizedBox(height: 16),

          // Add another language entry
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                languageEntries.add(LanguageEntry());
              });
            },
            icon: const Icon(Icons.add, color: primaryColor),
            label: Text(
              'Add Another Language',
              style: content,
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          GestureDetector(
            onTap: _saveLanguagesToFirestore,
            child: Container(
              width: 150,
              height: 52,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: Text(
                  'Save Languages',
                  style: GoogleFonts.raleway(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageEntry {
  String? language;
  String? proficiency;

  final List<String> languages = [
    'English',
    'Bahasa Indonesia',
    'French',
    'Spanish',
    'German',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic'
  ];

  final List<String> proficiencies = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Fluent',
    'Native'
  ];

  bool validate() {
    return language != null && proficiency != null;
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language',
          style: subHeader,
        ),
        const SizedBox(height: 10),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xBF5F5F5F), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select Language', style: content),
              value: language,
              items: languages
                  .map((String lang) => DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang, style: content),
                      ))
                  .toList(),
              onChanged: (value) {
                language = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Proficiency',
          style: subHeader,
        ),
        const SizedBox(height: 10),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xBF5F5F5F), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select Proficiency', style: content),
              value: proficiency,
              items: proficiencies
                  .map((String prof) => DropdownMenuItem<String>(
                        value: prof,
                        child: Text(prof, style: content),
                      ))
                  .toList(),
              onChanged: (value) {
                proficiency = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

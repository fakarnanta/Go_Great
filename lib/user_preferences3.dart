import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences3 extends StatefulWidget {
  const Preferences3({Key? key}) : super(key: key);

  @override
  State<Preferences3> createState() => _Preferences3State();
}

class _Preferences3State extends State<Preferences3> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 248,
                    ),
                    Text(
                      'How shall \nwe call you?',
                      style: header,
                    ),
                    SizedBox(
                      height: 31,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      width: MediaQuery.of(context).size.width * 1,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xBF5F5F5F),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        style: content,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: content,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      _storeSelectedName();
                      print('name = ${_nameController.text}');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFD9D9D9),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Finish',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _storeSelectedName() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the Firebase Auth display name
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(_nameController.text);

      // Store the selected name in Firestore (optional for additional storage)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'name': _nameController.text}, SetOptions(merge: true));

      String? username = FirebaseAuth.instance.currentUser?.displayName;

      print('Selected name stored in Firestore: ${_nameController.text}');
      print(username);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("Error updating display name or storing in Firestore: $e");
      // Handle errors appropriately, e.g., display error messages to the user
    }
  }
}

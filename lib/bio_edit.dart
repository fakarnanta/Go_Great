import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class BioEdit extends StatelessWidget {
  const BioEdit({super.key});

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
                Text(
                  'Bio',
                  style: subHeader,
                ),
                SizedBox(height: 10,),
                BioForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BioForm extends StatefulWidget {
  const BioForm({super.key});

  @override
  State<BioForm> createState() => _BioFormState();
}

class _BioFormState extends State<BioForm> {
  final _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            maxLines: null, 
            keyboardType: TextInputType.multiline, 
            controller: _bioController,
            style: content, 
            decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: content, 
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 20,),
           GestureDetector(
              onTap: () async {
                  try {
                  await updateCurrentUserBio(_bioController.text);
                   AnimatedSnackBar.material(
                          'Bio successfully added!',
                          type: AnimatedSnackBarType.success,
                        ).show(context);
                  _bioController.clear();
                } catch (e) {
                   AnimatedSnackBar.material(
                          e.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                }
              },
              child: Container(
                width: 150,
                height: 52,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(32),
              ),
              child: Center(child: Text('Update bio!', style: GoogleFonts.raleway(fontSize: 14, color: Colors.white),)),
                      ),
            )],
    );
  }

  Future<void> updateCurrentUserBio(String bio) async {
  if (bio.trim().isEmpty) {
    throw Exception('Bio cannot be empty');
  }

  try {

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }


    final userId = currentUser.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'bio': bio.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); 

    print('Bio updated successfully for user: $userId');
  } catch (e) {
    print('Error updating bio: $e');
    throw Exception('Failed to update bio');
  }
}

}

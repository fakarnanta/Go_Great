import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:go_great/user_preferences1.dart';

class Preferences0 extends StatefulWidget {
  const Preferences0({super.key});

  @override
  State<Preferences0> createState() => _Preferences0State();
}

class _Preferences0State extends State<Preferences0> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              'What are you ?',
              style: header,
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              'Tell us what’s your position join for',
              style: content,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/illustration1.png',
                width: 183,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            PositionForm(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}

class PositionButton extends StatefulWidget {
  final String position;
  final String description;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color defaultColor;
  final bool isSelected;

  const PositionButton({
    required this.position,
    required this.description,
    required this.onTap,
    required this.selectedColor,
    required this.defaultColor,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<PositionButton> createState() => _PositionButtonState();
}

class _PositionButtonState extends State<PositionButton> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: ShapeDecoration(
          color: widget.isSelected
              ? const Color.fromARGB(255, 201, 201, 201)
              : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFE8E8E8)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.position,
              style: subHeader,
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              widget.description,
              style: content,
            )
          ],
        ),
      ),
    );
  }
}

class PositionForm extends StatefulWidget {
  const PositionForm({Key? key}) : super(key: key);

  @override
  State<PositionForm> createState() => _PositionFormState();
}

class _PositionFormState extends State<PositionForm> {
  String selectedPosition = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PositionButton(
              selectedColor: grey,
              defaultColor: Colors.white,
              position: 'Talent',
              description: 'I’m looking for\njob project and want to learn.',
              onTap: () {
                setState(() {
                  selectedPosition = 'Talent';
                  print('selectedPosition = Talent');
                });
              },
              isSelected: selectedPosition == 'Talent',
            ),
            SizedBox(width: 16),
            PositionButton(
              selectedColor: grey,
              defaultColor: Colors.white,
              position: 'Company',
              description: 'I want to hiring\nfor a project',
              onTap: () {
                setState(() {
                  selectedPosition = 'Company';
                  print('selectedPosition = Company');
                });
              },
              isSelected: selectedPosition == 'Company',
            ),
          ],
        ),
        SizedBox(
          height: 110,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
              onTap: () {
                _storeSelectedPosition();
              },
              child: SvgPicture.asset('assets/nextbutton.svg')),
        )
      ],
    );
  }

  Future<void> _storeSelectedPosition() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Store the selected position in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'selectedPosition': selectedPosition}, SetOptions(merge: true));

      print('Selected position stored in Firestore: $selectedPosition');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Preferences1()),
      );
    } catch (e) {
      print("Error storing selected position: $e");
    }
  }
}

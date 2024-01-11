import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/onboarding_screen.dart';
import 'package:go_great/user_preferences3.dart';
import 'package:google_fonts/google_fonts.dart';

class Preferences2 extends StatelessWidget {
  const Preferences2({super.key});

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
            Text(
              'What’s your goals?',
              style: header,
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              'Different people come to join with a various reasons. We want to give the opportunities that fits with your goal.',
              style: content,
            ),
            SizedBox(
              height: 30,
            ),
            TilesGoals(data: Data),
          
            
          ],
        ),
      )),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'What’s your goals?',
          style: header,
        ),
        Text(
          'Different people come to join with a various reasons. We want to give the opportunities that fits with your goal.',
          style: content,
        ),
      ],
    );
  }
}

class TilesGoals extends StatefulWidget {
  final List<Tiles> data;

  TilesGoals({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TilesGoals> createState() => _TilesGoalsState();
}

class _TilesGoalsState extends State<TilesGoals> {
  String? selectedGoal;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 17,
            mainAxisSpacing: 13,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                selectedGoal = widget.data[index].text.data;
                print('selectedGoal = ${widget.data[index].text.data}');
              },
              child: Container(
                padding: EdgeInsets.all(10),
                height: 250,
                width: 144,
                decoration: ShapeDecoration(
                  color: Colors.white,
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
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 100, child: Center(child: widget.data[index].icon)),
                    Text(
                      widget.data[index].text.data ?? ' ',
                      style: content,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
          SizedBox(
              height: 140,
            ),
        Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  _storeSelectedGoals();
                },
                child: SvgPicture.asset('assets/nextbutton.svg'),
              ),
            )
      ],
    );
  }

  Future<void> _storeSelectedGoals() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Store the selected position in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'goals': selectedGoal}, SetOptions(merge: true));

      print('Selected goals stored in Firestore: $selectedGoal');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Preferences3()),
      );
    } catch (e) {
      print("Error storing selected position: $e");
    }
  }
}

class Tiles {
  final Image icon;
  final Text text;

  Tiles({
    required this.icon,
    required this.text,
  });
}

final List<Tiles> Data = [
  Tiles(
      icon: Image.asset('assets/goal1.png'),
      text: Text(
        'To learn more and enhance my skills',
        style: content,
      )),
  Tiles(
      icon: Image.asset('assets/goal2.png'),
      text: Text(
        'To get an experiences more',
        style: content,
      )),
  Tiles(
      icon: Image.asset('assets/goal3.png'),
      text: Text(
        'To earn income or side hustle',
        style: content,
      )),
  Tiles(
      icon: Image.asset('assets/goal4.png'),
      text: Text(
        'There are other reasons for it',
        style: content,
      )),
];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/user_preferences2.dart';
import 'package:line_icons/line_icon.dart';

class Preferences1 extends StatefulWidget {
  const Preferences1({super.key});

  @override
  State<Preferences1> createState() => _Preferences1State();
}

class _Preferences1State extends State<Preferences1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
        child: Column(
          children: [Header()],
        ),
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  final String selectedOption = 'Software Developer';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
          ),
          Text(
            'What’s describe \nyou the best?',
            style: header,
          ),
          SizedBox(
            height: 11,
          ),
          Text(
            'Tell us what field of technology are you currently in',
            style: content,
          ),
          SizedBox(
            height: 26,
          ),
          MyDropDown(
            items: [
              'Data Analyst',
              'Software Developer',
              'Hardware Engineer',
              'IT Support',
              'Mobile Developer',
              'Frontend Developer',
              'Backend Developer'
            ],
            selectedOption: selectedOption,
          ),
        ],
      ),
    );
  }
}

class DropDownList extends StatefulWidget {
  const DropDownList({Key? key}) : super(key: key);

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  String dropdownValue = 'anjay';

  var items = [
    'Data Analyst',
    'Software Developer',
    'Hardware Engineer',
    'IT Support',
    'Mobile Developer',
    'Frontend Developer',
    'Backend Developer'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 32,
      padding: EdgeInsets.all(15),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
          ),
        ),
      ),
    );
  }
}

class MyDropDown extends StatefulWidget {
  final List<String> items;
  final String selectedOption;

  const MyDropDown({required this.items, required this.selectedOption});

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.all(10),
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
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                icon: SvgPicture.asset('assets/chevrondown.svg',
                width: 20,
                ),
                isExpanded: true,
                value: dropdownValue,
                items: widget.items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: content,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 280,),
         Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
              onTap: () {
                _storeSelectedJob();
              },
              child: SvgPicture.asset('assets/nextbutton.svg')),
                 )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedOption;
  }

   Future<void> _storeSelectedJob() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Store the selected position in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'job': dropdownValue}, SetOptions(merge: true));

      print('Selected job stored in Firestore: $dropdownValue');
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Preferences2()),
            );
    } catch (e) {
      print("Error storing selected position: $e");
    }
  }
}

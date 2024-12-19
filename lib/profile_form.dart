import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:go_great/profile_currentUser.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
            children: [
              Header(),
              SizedBox(height: 30),
              ProfileBodyForm(
                countryCityMap: {
                  'Indonesia': ['Jakarta', 'Surabaya', 'Bandung'],
                  'Malaysia': ['Kuala Lumpur', 'Penang', 'Johor Bahru'],
                  'Thailand': ['Bangkok', 'Chiang Mai', 'Phuket'],
                  'Vietnam': ['Hanoi', 'Ho Chi Minh City', 'Da Nang'],
                },
                languages: [
                  'English',
                  'Indonesian',
                  'Malay',
                  'Thai',
                  'Vietnamese',
                  'Mandarin',
                ],
              )
            ],
          ),
        ),
      )),
    );
    ;
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/splash.png',
          width: 80,
          color: grey,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Your Profile',
          style: header,
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            padding: EdgeInsets.all(7),
            width: MediaQuery.of(context).size.width * 1,
            height: 56,
            decoration: ShapeDecoration(
              color: Color(0xBFD3D3D3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Color(0xFFC40202),
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.01,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Please complete your profile fisrt to apply the projects and lessons',
                    style: content,
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class ProfileBodyForm extends StatefulWidget {
  final Map<String, List<String>> countryCityMap;
  final List<String> languages;

  const ProfileBodyForm(
      {required this.countryCityMap, required this.languages, super.key});

  @override
  State<ProfileBodyForm> createState() => _ProfileBodyFormState();
}

class _ProfileBodyFormState extends State<ProfileBodyForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final String selectedOption = 'Indonesia';

  final Map<String, List<String>> countryCityMap = {
    'Indonesia': ['Jakarta', 'Surabaya', 'Bandung'],
    'Malaysia': ['Kuala Lumpur', 'Penang', 'Johor Bahru'],
    'Thailand': ['Bangkok', 'Chiang Mai', 'Phuket'],
    'Vietnam': ['Hanoi', 'Ho Chi Minh City', 'Da Nang'],
  };

  String? selectedCountry;
  String? selectedCity;
  String? preferredLanguage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _nameController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        MyDropDown(
          items: widget.countryCityMap.keys.toList(),
          selectedOption: selectedCountry,
          hint: 'Select a Country',
          onChanged: (String? country) {
            setState(() {
              selectedCountry = country;
              selectedCity = null; // Reset city when country changes
            });
          },
        ),
        SizedBox(
          height: 16,
        ),
        MyDropDown(
          items: selectedCountry != null
              ? widget.countryCityMap[selectedCountry]!
              : [],
          selectedOption: selectedCity,
          hint: 'Select a City',
          onChanged: (String? city) {
            if (selectedCountry == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select a country first!'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            setState(() {
              selectedCity = city;
            });
          },
        ),
        SizedBox(
          height: 16,
        ),
        MyDropDown(
          items: widget.languages,
          selectedOption: preferredLanguage,
          hint: 'Preferred Language',
          onChanged: (String? language) {
            setState(() {
              preferredLanguage = language;
            });
          },
        ),
        SizedBox(
          height: 16,
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
          height: 16,
        ),
        RichText(
            text: TextSpan(
                text: 'Note:',
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                text:
                    ' You can fill in your card information either now or later to withdrawal your money from the project. The money will be calculated in our system,',
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: ' add methods',
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: ' to exchange it',
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal),
              )
            ])),
        SizedBox(
          height: 32,
        ),
        GestureDetector(
          onTap: () {
            uploadToFirestore();
          },
          child: Container(
            width: 232,
            height: 52,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
                child: Text(
              'Submit',
              style: GoogleFonts.raleway(fontSize: 18, color: Colors.white),
            )),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> uploadToFirestore() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Store data in Firestore under 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'country': selectedCountry,
        'city': selectedCity,
        'preferredLanguage': preferredLanguage,
        'isProfileCompleted': true, 
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
      });

      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          selectedCountry == null ||
          selectedCity == null ||
          preferredLanguage == null) {
        AnimatedSnackBar.material(
          'Please fill all the form',
          type: AnimatedSnackBarType.warning,
        ).show(context);
        return;
      }
      AnimatedSnackBar.material(
        'Profile successfully added',
        type: AnimatedSnackBarType.success,
      ).show(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Profile()), 
      );
    } catch (e) {
      print("Error uploading data to Firestore: $e");
     AnimatedSnackBar.material(
          'Could not save data!',
          type: AnimatedSnackBarType.error,
        ).show(context);
    }
  }
}

class MyDropDown extends StatelessWidget {
  final List<String> items;
  final String? selectedOption;
  final String hint;
  final ValueChanged<String?> onChanged;

  const MyDropDown({
    required this.items,
    required this.selectedOption,
    required this.hint,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            hint,
            style: content,
          ),
          value: selectedOption,
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

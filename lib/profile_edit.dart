import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:go_great/profile_currentUser.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
              Header(),
              SizedBox(height: 30),
              ProfileBodyForm(
                countryCityMap: {
                  'Indonesia': ['Jakarta', 'Surabaya', 'Bandung'],
                  'Malaysia': ['Kuala Lumpur', 'Penang', 'Johor Bahru'],
                  'Thailand': ['Bangkok', 'Chiang Mai', 'Phuket'],
                  'Vietnam': ['Hanoi', 'Ho Chi Minh City', 'Da Nang'],
                },
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
        Text(
          'Profile Edit',
          style: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class ProfileBodyForm extends StatefulWidget {
  final Map<String, List<String>> countryCityMap;

  const ProfileBodyForm({required this.countryCityMap, super.key});

  @override
  State<ProfileBodyForm> createState() => _ProfileBodyFormState();
}

class _ProfileBodyFormState extends State<ProfileBodyForm> {
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _linkedinController = TextEditingController();
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
            style: content,
            decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: content,
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _jobController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Job Title',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
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
            controller: _linkedinController,
            style: content,
            decoration: InputDecoration(
                labelText: 'Linkedin username',
                labelStyle: content,
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
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
            style: content,
            decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: content,
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(
          height: 16,
        ),
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
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': _nameController.text,
        'job': _jobController.text,
        'country': selectedCountry,
        'city': selectedCity,
      });

      if (_nameController.text.isEmpty ||
          _jobController.text.isEmpty ||
          selectedCountry == null ||
          selectedCity == null) {
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
            builder: (context) => Profile()), // Your HomePage widget
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

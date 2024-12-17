import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/bio_edit.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/education_edit.dart';
import 'package:go_great/experience_edit.dart';
import 'package:go_great/language_edit.dart';
import 'package:go_great/login.dart';
import 'package:go_great/profile_edit.dart';
import 'package:go_great/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<Map<String, dynamic>> fetchUserProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User profile not found');
    }
  }

void showLogOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 21),
          width: 311.04,
          height: 180,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are You Sure You Want to Log Out?',
                style: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            
              SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Container(
                      width: 101.72,
                      height: 43,
                      decoration: ShapeDecoration(
                        color: Color(0xFFC40202),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(179),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.raleway(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                    
                      logOut(context);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Container(
                      width: 101.72,
                      height: 43,
                      decoration: ShapeDecoration(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(179),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.raleway(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}


Future<void> logOut(BuildContext context) async {
  try {
    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    
    await FirebaseAuth.instance.signOut();

    AnimatedSnackBar.material(
      'Successfully logged out',
      type: AnimatedSnackBarType.success,
    ).show(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  } catch (e) {
    print('Error logging out: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading profile: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(child: Text('Profile not found.'));
            } else {
              final profileData = snapshot.data!;
              final name = profileData['name'] ?? 'Unknown Name';
              final city = profileData['city'] ?? 'Unknown City';
              final country = profileData['country'] ?? 'Unknown City';
              final job = profileData['job'] ?? 'Unknown Job';

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Header(
                      name: name,
                      country: country,
                      city: city,
                      job: job,
                    ),
                    SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 37),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            LinkedinEmail(
                              linkedin: 'aefjnawdm',
                              email: 'awfhnawdjnaf',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Bio(
                              bio: profileData['bio'],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            EducationList(),
                            SizedBox(
                              height: 10,
                            ),
                            LanguageList(),
                            SizedBox(
                              height: 30,
                            ),
                            Portfolio(),
                            SizedBox(
                              height: 30,
                            ),
                            WorkExperienceList(),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Want to log out? ',
                                    ),
                                    TextSpan(
                                      text: 'Log out here',
                                      style: GoogleFonts.raleway(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showLogOut(context);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.name,
    required this.country,
    required this.city,
    required this.job,
    this.image,
  }) : super(key: key);

  final String name;
  final String country;
  final String city;
  final String job;
  final String? image;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  File? _image;
  String? _imageUrl;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImageToFirebase(_image!);
    }
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = _storage.ref().child('profile_pictures/${user.uid}.jpg');
        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _checkProfilePicture() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = _storage.ref().child('profile_pictures/${user.uid}.jpg');

        try {
          String downloadURL = await ref.getDownloadURL();
          setState(() {
            _imageUrl = downloadURL;
          });
        } catch (e) {
          // File doesn't exist
          print('File does not exist: $e');
        }
      }
    } catch (e) {
      print('Error fetching image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 320,
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Image.asset(
                'assets/profile_banner_temp.jpeg',
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileEdit()));
                            },
                            icon: LineIcon.userEdit()),
                      ],
                    ),
                  ),
                  Text(
                    (FirebaseAuth.instance.currentUser?.displayName ?? 'User'),
                    style: GoogleFonts.sourceSans3(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/location.svg'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.city,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      ),
                      Text(
                        ', ',
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      ),
                      Text(
                        widget.country,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    widget.job,
                    style: GoogleFonts.openSans(fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      Positioned(
        left: 15,
        top: 70,
        child: GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 218, 217, 217),
            radius: 60,
            backgroundImage: _imageUrl != null
                ? NetworkImage(_imageUrl!)
                : widget.image != null
                    ? FileImage(File(widget.image!)) // Local image path
                    : AssetImage('assets/default_pfp.jpg') // Default image
                        as ImageProvider,
          ),
        ),
      ),
    ]);
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.name,
    required this.location,
    required this.job,
  }) : super(key: key);

  final String name;
  final String location;
  final String job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 64,
                decoration: ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
              ),
              Column(
                children: [],
              )
            ],
          )
        ],
      ),
    );
  }
}

class LinkedinEmail extends StatelessWidget {
  const LinkedinEmail({required this.linkedin, required this.email, super.key});

  final String linkedin;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 64,
          width: 6,
          decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(29)),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              linkedin,
              style: GoogleFonts.openSans(fontSize: 14, color: primaryColor),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              email,
              style: content,
            )
          ],
        )
      ],
    );
  }
}

class Bio extends StatelessWidget {
  const Bio({required this.bio, super.key});

  final String bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bio',
              style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
              icon: LineIcon.edit(),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BioEdit()),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x59000000)),
                borderRadius: BorderRadius.circular(18),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ]),
          child: bio.isEmpty
              ? Text(
                  'No bio found, create it!',
                  style: content,
                )
              : Text(
                  bio,
                  style: content,
                ),
        ),
      ],
    );
  }
}

class EducationList extends StatelessWidget {
  const EducationList({super.key});

  Future<List<Map<String, dynamic>>> _fetchEducationData() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch data from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('education')
          .get();

      // Map data into a list of maps
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching education data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Education',
              style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
                icon: LineIcon.edit(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EducationEdit()),
                  );
                }),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchEducationData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading education details'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No education details found',
                  style: content,
                ),
              );
            } else {
              final educationList = snapshot.data!;
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: educationList.length,
                        itemBuilder: (context, index) {
                          final education = educationList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 64,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      education['university'] ??
                                          'No university',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${education['major'] ?? 'No major'}',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 16,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${education['schoolPeriod']['start']} - ${education['schoolPeriod']['end']}',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 16,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class LanguageList extends StatelessWidget {
  const LanguageList({super.key});

  Future<List<Map<String, dynamic>>> _fetchEducationData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('language')
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching language data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Language',
              style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
                icon: LineIcon.edit(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguageEdit()),
                  );
                }),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchEducationData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading language details'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No language details found',
                  style: content,
                ),
              );
            } else {
              final languageList = snapshot.data!;
              return SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: languageList.length,
                        itemBuilder: (context, index) {
                          final language = languageList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 64,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['language'] ?? 'No university',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      language['proficiency'],
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 16,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  String? fileName;
  String? downloadURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFile();
  }

  Future<void> fetchFile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if document exists and contains the required fields
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          fileName =
              data['fileName'] ?? null; // Set to null if fileName doesn't exist
          downloadURL =
              data['cvURL'] ?? null; // Set to null if cvURL doesn't exist
        });
      }
    } catch (e) {
      print('Error fetching file: $e');
    }
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() => isLoading = true);

        String userId = FirebaseAuth.instance.currentUser!.uid;
        File file = File(result.files.single.path!);
        String name = result.files.single.name;

        String firebasePath = 'uploads/$userId/$name';
        Reference storageRef = FirebaseStorage.instance.ref(firebasePath);
        await storageRef.putFile(file);

        String url = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fileName': name,
          'cvURL': url,
        }, SetOptions(merge: true));

        setState(() {
          fileName = name;
          downloadURL = url;
          isLoading = false;
        });

        print('File uploaded successfully!');
      }
    } catch (e) {
      print('Error uploading file: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> openFile(String? downloadURL) async {
    if (downloadURL != null) {
      final Uri uri = Uri.parse(downloadURL);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch the URL.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open PDF. Please try again.')),
        );
      }
    } else {
      print('Invalid URL provided.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Portfolio',
              style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
              icon:
                  Icon(Icons.add_circle_outline, size: 28, color: Colors.black),
              onPressed: uploadFile,
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: 153,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'MyCV',
                style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              SizedBox(height: 15),

              // File Info Container
              GestureDetector(
                onTap: () async {
                  await openFile(downloadURL);
                  print(downloadURL);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName ?? 'No file uploaded',
                              style: GoogleFonts.raleway(
                                  fontSize: 12, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'PDF',
                              style: GoogleFonts.raleway(
                                  fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class WorkExperienceList extends StatelessWidget {
  const WorkExperienceList({super.key});

  Future<List<Map<String, dynamic>>> _fetchWorkExperienceData() async {
    try {
      // Get user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch data from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workExperience')
          .get();

      // Map data into a list of maps
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching work experience data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Work Experience',
              style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
              icon: LineIcon.edit(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkExperienceEdit()),
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchWorkExperienceData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading work experience details'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No work experience details found',
                  style: content,
                ),
              );
            } else {
              final workExperienceList = snapshot.data!;
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: workExperienceList.length,
                        itemBuilder: (context, index) {
                          final workExperience = workExperienceList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 64,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workExperience['company'] ?? 'No company',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      workExperience['position'] ??
                                          'No position',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 16,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${workExperience['start']} - ${workExperience['end']}',
                                      style: GoogleFonts.sourceSans3(
                                        fontSize: 16,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }
}

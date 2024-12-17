import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/bio_edit.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/education_edit.dart';
import 'package:go_great/experience_edit.dart';
import 'package:go_great/language_edit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class ProfileOther extends StatelessWidget {
  final String userId;

  const ProfileOther({super.key, required this.userId});

  Future<Map<String, dynamic>> fetchUserProfile() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User profile not found');
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
              final linkedin = profileData['linkedin'] ?? 'Unknown linkedin';
              final email = profileData['email'] ?? 'Unknown email';

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Header(
                      userId: userId,
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
                              linkedin: profileData[linkedin] ?? 'Not added yet',
                              email: profileData[email] ?? 'Not added yet',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Bio(
                              bio: profileData['bio'] ?? '',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            EducationList(
                              userId: userId,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            LanguageList(
                              userId: userId,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Portfolio(userId: userId),
                            SizedBox(
                              height: 30,
                            ),
                            WorkExperienceList(userId: userId),
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
    required this.userId,
    this.image,
  }) : super(key: key);

  final String name;
  final String country;
  final String city;
  final String job;
  final String userId; // userId passed as required parameter
  final String? image;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  File? _image;
  String? _imageUrl;
  String? _userName;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _checkProfilePicture();
  }

  Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? 'User';
        });
      } else {
        print('User document not found for ID: ${widget.userId}');
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> _checkProfilePicture() async {
    try {
      final ref = _storage.ref().child('profile_pictures/${widget.userId}.jpg');
      try {
        String downloadURL = await ref.getDownloadURL();
        setState(() {
          _imageUrl = downloadURL;
        });
      } catch (e) {
        print('No profile picture found for userId ${widget.userId}: $e');
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
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
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    _userName ?? 'User',
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
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 218, 217, 217),
          radius: 60,
          backgroundImage: _imageUrl != null
              ? NetworkImage(_imageUrl!)
              : widget.image != null
                  ? FileImage(File(widget.image!))
                  : const AssetImage('assets/default_pfp.jpg') as ImageProvider,
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
            Row(
              children: [
                Text(
                  linkedin ?? 'Unknown linkedin',
                  style:
                      GoogleFonts.openSans(fontSize: 14, color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              email ?? 'Unknown email',
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
    final displayBio = bio?.isEmpty ?? true ? 'No bio found, create it!' : bio!;

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
              ? Center(
                  child: Text(
                    'No bio found',
                    style: content,
                  ),
                )
              : Text(
                  displayBio,
                  style: content,
                ),
        ),
      ],
    );
  }
}

class EducationList extends StatelessWidget {
  final String userId;
  const EducationList({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchEducationData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('education')
          .get();

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
  final String userId;
  const LanguageList({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchEducationData() async {
    try {
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
  final String userId;
  const Portfolio({super.key, required this.userId});

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
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
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
  final String userId;
  const WorkExperienceList({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchWorkExperienceData() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workExperience')
          .get();

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/add_project.dart';
import 'package:go_great/chat.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/lesson_list.dart';
import 'package:go_great/my_flutter_app_icons.dart';
import 'package:go_great/my_projects.dart';
import 'package:go_great/onboarding_screen.dart';
import 'package:go_great/profile_currentUser.dart';
import 'package:go_great/profile_form.dart';
import 'package:go_great/project_detail.dart';
import 'package:go_great/project_list.dart';
import 'package:go_great/saved_list.dart';
import 'package:go_great/soon.dart';
import 'package:go_great/submit_temp.dart';
import 'package:go_great/talent_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 


  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(isLoggedIn: isLoggedIn,));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGreat',
      home: isLoggedIn ? HomePage() : OnBoardingScreen(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFAB = false;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late String greetingUsername = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final databaseReference =
      FirebaseDatabase.instanceFor(app: Firebase.app()).ref().child('projects');
  late List<ProjectRecommend> projectRecommends = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
    _checkUserPreference();
  }

  void fetchProjects() async {
    // Fetch projects
    await firestore.collection('projects').snapshots().listen((snapshot) {
      setState(() {
        projectRecommends = snapshot.docs
            .map((doc) => ProjectRecommend.fromFirestore(doc))
            .toList();
      });
    });

    // Fetch user data to get the username
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();

      // Check if the 'name' field exists in the document
      if (userDoc.exists &&
          userDoc.data() is Map<String, dynamic> &&
          (userDoc.data() as Map<String, dynamic>).containsKey('name')) {
        String username = userDoc['name'];
        String firstWord = username.split(' ')[0];
        print(userDoc['name']);
        setState(() {
          // Update the greeting with the fetched username
          greetingUsername = firstWord;
          print(greetingUsername);
        });
      } else {
        // Handle the case where the 'name' field is missing or null
        print('Name field is missing or null in the user document.');
      }
    }
  }

  Future<void> _checkUserPreference() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final preference = doc.data()?['selectedPosition'];
      setState(() {
        showFAB = preference == 'Company';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      floatingActionButton: showFAB
      ? FloatingActionButton.extended(
        onPressed: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProject()),
                    );
        },
        label: Text('Add Project', style: GoogleFonts.raleway(fontSize: 13, color: Colors.white),),
        backgroundColor: Color(0xFF063F5C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),// Update size as needed
        icon: SvgPicture.asset('assets/plus.svg'), 
      )
      : null,
    
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 80,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x7C000000),
              blurRadius: 17.40,
              offset: Offset(0, 15),
              spreadRadius: 11,
            )
          ],
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              gap: 8,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.white,
              tabs: [
                GButton(
                  icon: MyFlutterApp.home,
                  iconColor: primaryColor,
                  iconActiveColor: primaryColor,
                  text: 'Home',
                  textStyle: content,
                  onPressed: () {
                    _pageController.jumpToPage(0);
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                GButton(
                  icon: MyFlutterApp.albums,
                  iconColor: primaryColor,
                  iconActiveColor: primaryColor,
                  text: 'Saved',
                  textStyle: content,
                  onPressed: () {
                        if (showFAB) {
                        _pageController.jumpToPage(3); 
                        setState(() {
                          _selectedIndex = 3; 
                        });
                      } else {
                        _pageController.jumpToPage(1); 
                        setState(() {
                          _selectedIndex = 1; 
                        });
                      }
                    },
                ),
                GButton(
                  icon: MyFlutterApp.chatbubble,
                  iconColor: primaryColor,
                  iconActiveColor: primaryColor,
                  text: 'Chat',
                  textStyle: content,
                  onPressed: () {
                    _pageController.jumpToPage(2);
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              }),
        )),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Hello, ',
                                style: GoogleFonts.sourceSans3(
                                    color: primaryColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: (FirebaseAuth.instance.currentUser
                                            ?.displayName ??
                                        'User')
                                    .split(' ')
                                    .first,
                                style: GoogleFonts.sourceSans3(
                                    color: secondaryColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
 
                            String userId = FirebaseAuth.instance.currentUser!.uid;
                            bool isProfileCompleted = false;

                            try {
                             
                              DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                              if (userDoc.exists && userDoc['isProfileCompleted'] == true) {
                                isProfileCompleted = true;
                              }
                            } catch (e) {
                              print("Error checking profile status: $e");
                            }

                            if (isProfileCompleted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Profile()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileForm()),
                              );
                            }
                          },
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Soon()),
                          );
                    },
                    child: SearchBar()),
                  SizedBox(
                    height: 40,
                  ),
                  Recommended(),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommendation',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: primaryColor),
                      ),
                      Text(
                        'See All',
                        style:
                            GoogleFonts.sourceSans3(fontSize: 14, color: grey),
                      )
                    ],
                  ),
                  SizedBox(height: 18),
                  ProjectRecommend(
                    time: DateTime(2024, 1, 27),
                    title:
                        'Build a Cloud Based AI Software\nfor Security Cameras',
                    jobState: 'On-Going',
                    location: 'United States',
                    description:
                        'I am looking to build a cloud based software that will utilize artificial intelligence and machine learning for surveillance cameras.The goal is to add AI functionalities',
                    personNeed: '5-10',
                    projectId: 'OR4leBeJED9MmUlNTneS',
                    projectLength: '3 months',
                    companyName: 'Shopify',
                    companySize: '100-150 person',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: projectRecommends.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final currentProjectId =
                                projectRecommends[index].projectId;
                            print(
                                'Clicked on project with ID: ${currentProjectId ?? "N/A"}');
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: ProjectRecommend(
                              projectId: projectRecommends[index].projectId,
                              time: projectRecommends[index].time,
                              title: projectRecommends[index].title,
                              jobState: projectRecommends[index].jobState,
                              location: projectRecommends[index].location,
                              description: projectRecommends[index].description,
                              personNeed: projectRecommends[index].personNeed,
                              companyName: projectRecommends[index].companyName,
                              companySize: projectRecommends[index].companySize,
                              projectLength: projectRecommends[index].projectLength,
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          )),
          SavedList(),
          Chat(),
          MyProject(),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});
  //jangan lupa kerjakan fungsinya, state, delegate, dan list view(mungkin ke page lain)

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Icon(
                LineIcons.search,
                size: 22,
                color: grey,
              )),
          Text(
            'Find Project, talent, lessons...',
            style: GoogleFonts.sourceSans3(fontSize: 16, color: grey),
          ),
        ],
      ),
    );
  }
}

class Recommended extends StatelessWidget {
  const Recommended({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          RecommendedCard(
            title: 'Project',
            subtitle: 'Find company to join project\nthat suit you',
            bgColor: secondaryColor,
            textColor: primaryColor,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectList()),
              );
            },
          ),
          RecommendedCard(
            title: 'Lesson',
            subtitle: 'Find the lessons from the\nproject you have',
            bgColor: primaryColor,
            textColor: Colors.white,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LessonList()),
              );
            },
          ),
          RecommendedCard(
            title: 'Talent',
            subtitle: 'Find talent by your own to\nwork and learn together',
            bgColor: secondaryColor,
            textColor: primaryColor,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TalentList()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.textColor,
    required this.press,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Color bgColor;
  final Color textColor;
  final VoidCallback press; // Use VoidCallback instead of Function

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(right: 15),
        width: 223,
        height: 158,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
              SizedBox(
                height: 4,
              ),
              Text(
                subtitle,
                style: GoogleFonts.sourceSans3(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              ),
            ]),
      ),
    );
  }
}

class ProjectRecommend extends StatefulWidget {
  ProjectRecommend({
    Key? key,
    required this.time,
    required this.title,
    required this.jobState,
    required this.location,
    required this.description,
    required this.personNeed,
    required this.projectId,
    this.projectLength,
    this.companyName,
    this.companySize,
    this.tag,
  });

  DateTime time;
  String title;
  String jobState;
  String location;
  String description;
  String personNeed;
  final String? projectId;
  String? projectLength;
  String? companyName;
  String? companySize;
  List<String>? tag;

  factory ProjectRecommend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime time;
    if (data['time'] != null && data['time'] is Timestamp) {
      time = (data['time'] as Timestamp).toDate();
    } else {
      time = DateTime.now();
    }

    return ProjectRecommend(
      projectId: doc.id,
      time: time,
      title: data['title'] ?? '',
      jobState: data['jobState'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      personNeed: data['personNeed'] ?? '',
    );
  }

  @override
  State<ProjectRecommend> createState() => _ProjectRecommendState();
}

class _ProjectRecommendState extends State<ProjectRecommend> {
  bool isSaved = false;
  late String userId;

  @override
  void initState() {
    super.initState();
  
    getCurrentUserId();
  }

  void checkSavedState() async {
      bool saved = await isProjectSaved(widget.projectId ?? '', userId);
      setState(() {
        isSaved = saved;
      });
  }

  Future<bool> isProjectSaved(String projectId, String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('saved_projects')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      List<dynamic> savedProjectIds = snapshot['project_ids'] ?? [];
      return savedProjectIds.contains(projectId);
    } else {
      return false;
    }
  }

  void getCurrentUserId() {
    // Use FirebaseAuth to get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      setState(() {
        userId = user.uid; // Set the user ID
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectDetail(
                        title: widget.title,
                        jobState: widget.jobState,
                        location: widget.location,
                        description: widget.description,
                        personNeed: widget.personNeed,
                        projectLength: widget.projectLength,
                        companyName: widget.companyName,
                        companySize: widget.companySize,
                      )),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 24),
            width: MediaQuery.of(context).size.width * 1,
            height: 272,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posted ${widget.time} ago',
                  style: GoogleFonts.openSans(
                      fontSize: 10, fontWeight: FontWeight.w400, color: grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.title,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/briefcase.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.jobState,
                      style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset('assets/location.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.location,
                      style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: grey),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.description,
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5F5F5F)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4, // adjust based on your needs
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/people.svg'),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '5 to 10',
                      style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: grey),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        toggleSavedState();
                      },
                      child: SvgPicture.asset(
                        isSaved
                            ? 'assets/bookmark_filled.svg'
                            : 'assets/bookmark.svg',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> addSavedProjectToFirestore(
      String projectId, String userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Define the path to the saved projects collection
      String savedProjectsCollection = 'users/$userId/savedProjects';

      // Check if the project is already saved to avoid duplication
      bool isSaved = await firestore
          .doc('$savedProjectsCollection/$projectId')
          .get()
          .then((doc) => doc.exists);
      if (!isSaved) {
        // If the project is not saved, add it to Firestore
        await firestore.doc('$savedProjectsCollection/$projectId').set({
          'projectId': projectId,
        });
        print('Project saved successfully!');
      } else {
        print('Project already saved.');
      }
    } catch (e) {
      print('Error saving project: $e');
      // Handle the error as needed
    }
  }

  Future<void> removeSavedProjectFromFirestore(
      String projectId, String userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Define the path to the saved projects collection
      String savedProjectsCollection = 'users/$userId/savedProjects';

      // Check if the project exists before attempting to remove it
      bool isSaved = await firestore
          .doc('$savedProjectsCollection/$projectId')
          .get()
          .then((doc) => doc.exists);

      if (isSaved) {
        // If the project is saved, remove it from Firestore
        await firestore.doc('$savedProjectsCollection/$projectId').delete();
        print('Project removed successfully!');
      } else {
        print('Project not found in saved projects.');
      }
    } catch (e) {
      print('Error removing project: $e');
      // Handle the error as needed
    }
  }

  void toggleSavedState() {
    // Check if userId is not null before proceeding
    if (userId != null) {
      // Toggle the saved state
      setState(() {
        isSaved = !isSaved;
      });

      // Call the function to add/remove the saved project from Firestore
      if (isSaved) {
        // Add the project to Firestore
        addSavedProjectToFirestore(widget.projectId ?? '', userId);
      } else {
        // Remove the project from Firestore
        removeSavedProjectFromFirestore(widget.projectId ?? '', userId);
      }
    }
  }
}

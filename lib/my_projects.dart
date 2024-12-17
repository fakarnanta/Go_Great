import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart'; // Assuming `ProjectRecommend` is from here

class ProjectDetails {
  Timestamp time;
  String title;
  String jobState;
  String location;
  String description;
  String personNeed;

  ProjectDetails({
    required this.time,
    required this.title,
    required this.jobState,
    required this.location,
    required this.description,
    required this.personNeed,
  });
}

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<List<ProjectDetails>> getProjectsForCurrentUser() async {
    try {
      User? user = await getCurrentUser();
      if (user == null) return [];

      QuerySnapshot querySnapshot = await _firestore
          .collection('projects')
          .where('userId', isEqualTo: user.uid)
          .get();

       return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      DateTime time;
      if (data['time'] != null && data['time'] is Timestamp) {
        time = (data['time'] as Timestamp).toDate();
      } else {
        time = DateTime.now();
      }

      return ProjectDetails(
        time: Timestamp.fromDate(time), // Ensure it uses a valid Timestamp
        title: data['title'] ?? 'Untitled',
        jobState: data['jobState'] ?? 'Unknown',
        location: data['location'] ?? 'Not specified',
        description: data['description'] ?? 'No description available',
        personNeed: data['personNeed'] ?? 'Not specified',
      );
    }).toList();
    } catch (e) {
      debugPrint('Error fetching projects: $e');
      return [];
    }
  }
}

class MyProject extends StatefulWidget {
  const MyProject({Key? key}) : super(key: key);

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  bool isCompany = false;
  late ProjectService projectService;
  late List<ProjectDetails> userProjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    projectService = ProjectService();
    fetchUserProjects();
    checkUserPreference();
  }

  Future<void> fetchUserProjects() async {
    try {
      final projects = await projectService.getProjectsForCurrentUser();
      setState(() {
        userProjects = projects;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching user projects: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkUserPreference() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final preference = doc.data()?['selectedPosition'];
        setState(() {
          isCompany = preference == 'Company';
        });
        
      } catch (e) {
        
        debugPrint('Error fetching user preference: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 55, left: 23, right: 23, bottom: 34),
              width: MediaQuery.of(context).size.width,
              height: 139,
              decoration: const ShapeDecoration(
                color: Color(0xFF063F5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Projects',
                    style: GoogleFonts.openSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/bookmark.svg',
                    color: Colors.white,
                    width: 40,
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        secondRingColor: primaryColor,
                        thirdRingColor: secondaryColor,
                        size: 50,
                      ),
                    )
                  : userProjects.isNotEmpty
                      ? SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userProjects.length,
                            itemBuilder: (context, index) {
                              final project = userProjects[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ProjectRecommend(
                                  time: project.time.toDate(),
                                  title: project.title,
                                  jobState: project.jobState,
                                  location: project.location,
                                  description: project.description,
                                  personNeed: project.personNeed,
                                  projectId: '', // Pass projectId if available
                                ),
                              );
                            },
                          ),
                      )
                      : Center(
                          child: Text(
                            "You haven't added any projects yet",
                            style: content,
                            textAlign: TextAlign.start,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

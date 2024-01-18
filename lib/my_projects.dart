import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProjectDetails {
  DateTime? time;
  String title;
  String jobState;
  String location;
  String description;
  String personNeed;

  ProjectDetails({
    this.time,
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

      if (user == null) {
        // User not logged in, handle accordingly
        return [];
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('projects')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<ProjectDetails> projects = querySnapshot.docs
          .map((doc) => ProjectDetails(
                time: (doc['time'] as Timestamp?)?.toDate(),
                title: doc['title'],
                jobState: doc['jobState'],
                location: doc['location'],
                description: doc['description'],
                personNeed: doc['personNeed'],
              ))
          .toList();

      return projects;
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }
}

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  bool myProjects = false;
  late ProjectService projectService;
  late List<ProjectDetails> userProjects = [];

  void initState() {
    super.initState();
    projectService = ProjectService();
    fetchUserProjects();
  }

  Future<void> fetchUserProjects() async {
    userProjects = await projectService.getProjectsForCurrentUser();
    setState(() {});
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
        myProjects = preference == 'Company';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 55, left: 23, right: 23, bottom: 34),
            width: MediaQuery.of(context).size.width * 1,
            height: 139,
            decoration: ShapeDecoration(
              color: Color(0xFF063F5C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18)),
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
                      color: Colors.white),
                ),
                SvgPicture.asset(
                  'assets/bookmark.svg',
                  color: Colors.white,
                  width: 40,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: userProjects.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userProjects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ProjectRecommend(
                          time: DateTime.now(),
                          title: userProjects[index].title,
                          jobState: userProjects[index].jobState,
                          location: userProjects[index].location,
                          description: userProjects[index].description,
                          personNeed: userProjects[index].personNeed,
                          projectId: '',
                        ),
                      );
                    },
                  )
                : Center(
                    child: userProjects.isEmpty
                        ? Text("You haven't add project yet", style: content, textAlign: TextAlign.start,)
                        : LoadingAnimationWidget.discreteCircle(
                            color: const Color.fromARGB(255, 199, 199, 199),
                            secondRingColor: primaryColor,
                            thirdRingColor: secondaryColor,
                            size: 50)),
          ),
        ],
      )),
    );
  }
}

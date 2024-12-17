import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProjectDetails {
  DateTime time;
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

class SavedList extends StatefulWidget {
  const SavedList({super.key});

  @override
  State<SavedList> createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  late List<ProjectDetails> savedProjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedProjects();
  }

  Future<void> fetchSavedProjects() async {
    try {
  
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      
      if (userId.isNotEmpty) {
    
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('savedProjects')
            .get();

      
        List<String> projectIds = querySnapshot.docs.map((doc) => doc.id).toList();

        
        List<ProjectDetails> projects = await fetchProjectDetails(projectIds);

        setState(() {
          savedProjects = projects;
        });
      }
    } catch (e) {
      debugPrint('Error fetching saved projects: $e');
       AnimatedSnackBar.material(
            'Unexpected error!',
            type: AnimatedSnackBarType.error,
          ).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<ProjectDetails>> fetchProjectDetails(List<String> projectIds) async {
    List<ProjectDetails> projects = [];

    for (String projectId in projectIds) {
      DocumentSnapshot<Map<String, dynamic>> projectSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .get();

      if (projectSnapshot.exists) {
        final data = projectSnapshot.data()!;

        DateTime time;
        if (data['time'] != null && data['time'] is Timestamp) {
          time = (data['time'] as Timestamp).toDate();
        } else {
          time = DateTime.now();
        }

        ProjectDetails project = ProjectDetails(
          time: time,
          title: data['title'] ?? 'Untitled',
          jobState: data['jobState'] ?? 'Unknown',
          location: data['location'] ?? 'Not specified',
          description: data['description'] ?? 'No description available',
          personNeed: data['personNeed'] ?? 'Not specified',
        );

        projects.add(project);
      }
    }

    return projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
      
            Container(
              padding: const EdgeInsets.only(
                  top: 55, left: 23, right: 23, bottom: 34),
              width: MediaQuery.of(context).size.width,
              height: 139,
              decoration: const ShapeDecoration(
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
                    'Saved Projects',
                    style: GoogleFonts.openSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SvgPicture.asset(
                    'assets/bookmark.svg',
                    color: Colors.white,
                    width: 30,
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        secondRingColor: primaryColor,
                        thirdRingColor: secondaryColor,
                        size: 50,
                      ),
                    )
                  : savedProjects.isEmpty
                      ? Center(
                          child: Text(
                            "You haven't saved any projects yet.",
                            style: content,
                            textAlign: TextAlign.start,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: Column(
                              children: savedProjects
                                  .map((project) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: ProjectRecommend(
                                          time: project.time,
                                          title: project.title,
                                          jobState: project.jobState,
                                          location: project.location,
                                          description: project.description,
                                          personNeed: project.personNeed,
                                          projectId: '',
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

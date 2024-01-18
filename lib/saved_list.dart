import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
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

class SavedList extends StatefulWidget {
  const SavedList({super.key});

  @override
  State<SavedList> createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  late List<ProjectDetails> savedProjects = [];

  @override
  void initState() {
    super.initState();
    // Fetch the saved projects from Firestore
    fetchSavedProjects();
  }

  Future<void> fetchSavedProjects() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Check if the user ID is not empty
      if (userId.isNotEmpty) {
        // Query Firestore to get the saved projects for the current user
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('savedProjects')
                .get();

        // Map the query snapshot to a list of project IDs
        List<String> projectIds =
            querySnapshot.docs.map((doc) => doc.id).toList();

        // Fetch project details for each project ID
        List<ProjectDetails> projects = await fetchProjectDetails(projectIds);

        setState(() {
          savedProjects = projects;
        });
      }
    } catch (e) {
      print('Error fetching saved projects: $e');
    }
  }

  Future<List<ProjectDetails>> fetchProjectDetails(
      List<String> projectIds) async {
    List<ProjectDetails> projects = [];

    // Fetch project details for each project ID
    for (String projectId in projectIds) {
      DocumentSnapshot<Map<String, dynamic>> projectSnapshot =
          await FirebaseFirestore.instance
              .collection('projects') // Change this to your projects collection
              .doc(projectId)
              .get();

      if (projectSnapshot.exists) {
        // Create a ProjectDetails object from Firestore data
        ProjectDetails project = ProjectDetails(
          title: projectSnapshot['title'] ?? '',
          jobState: projectSnapshot['jobState'] ?? '',
          location: projectSnapshot['location'] ?? '',
          description: projectSnapshot['description'] ?? '',
          personNeed: projectSnapshot['personNeed'] ?? '',
        );

        // Add the project to the list
        projects.add(project);
      }
    }

    return projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saved', style: header),
                SizedBox(height: 28),
                savedProjects.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: savedProjects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ProjectRecommend(
                            time: DateTime.now(),
                            title: savedProjects[index].title,
                            jobState: savedProjects[index].jobState,
                            location: savedProjects[index].location,
                            description: savedProjects[index].description,
                            personNeed: savedProjects[index].personNeed,
                            projectId: '',
                          ),
                        );
                      },
                    )
                    : Center(
                      child:
                      LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        secondRingColor: primaryColor,
                        thirdRingColor: secondaryColor,
                         size: 50)
                    ), // Show loading indicator while fetching data
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_great/project_detail.dart';

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

class ProjectSearch extends StatefulWidget {
  const ProjectSearch({super.key});

  @override
  State<ProjectSearch> createState() => _ProjectSearchState();
}

class _ProjectSearchState extends State<ProjectSearch> {
  List<ProjectDetails> projects = [];
  bool isLoading = false;
  String searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      String normalizedQuery = searchQuery.toLowerCase();

      List<ProjectDetails> filteredProjects = snapshot.docs
          .map((doc) {
            final data = doc.data();

            DateTime time;
            if (data['time'] != null && data['time'] is Timestamp) {
              time = (data['time'] as Timestamp).toDate();
            } else {
              time = DateTime.now();
            }

            return ProjectDetails(
              time: time,
              title: data['title'] ?? 'Untitled',
              jobState: data['jobState'] ?? 'Unknown',
              location: data['location'] ?? 'Not specified',
              description: data['description'] ?? 'No description available',
              personNeed: data['personNeed'] ?? 'Not specified',
            );
          })
          .where((project) =>
              project.title.toLowerCase().contains(normalizedQuery))
          .toList();

      setState(() {
        projects = filteredProjects;
      });
    } catch (e) {
      debugPrint('Error fetching projects: $e');
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
              decoration: const BoxDecoration(
                color: Color(0xFF063F5C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                'Search Projects',
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  fetchProjects();
                },
                decoration: InputDecoration(
                  hintText: "Search projects...",
                  hintStyle: GoogleFonts.openSans(fontSize: 14),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),

            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        secondRingColor: const Color(0xFF063F5C),
                        thirdRingColor: const Color(0xFF1FA2A6),
                        size: 50,
                      ),
                    )
                  : projects.isEmpty
                      ? Center(
                          child: Text(
                            "No projects found.",
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectDetail(
                                      title: project.title,
                                      jobState: project.jobState,
                                      location: project.location,
                                      description: project.description,
                                      personNeed: project.personNeed,
                                    ),
                                  ),
                                );
                              },
                              child: ProjectCard(project: project),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectDetails project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Job State: ${project.jobState}',
            style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey),
          ),
          Text(
            'Location: ${project.location}',
            style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

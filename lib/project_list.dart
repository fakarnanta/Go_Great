import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final databaseReference =
      FirebaseDatabase.instanceFor(app: Firebase.app()).ref().child('projects');
  late List<ProjectRecommend> projectRecommends = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                width: MediaQuery.of(context).size.width * 1,
                height: 300,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFCB66),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/backbutton_blue.svg'),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'Projects',
                      style: header,
                    ),
                    Text(
                      'Find company to join project\nthat suit you',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 35,
                  left: 120,
                  child: Image.asset(
                    'assets/a3.png',
                    color: Color.fromARGB(255, 226, 165, 43),
                  ))
            ]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23, vertical: 37),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: projectRecommends.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: ProjectRecommend(
                        time: projectRecommends[index].time,
                        title: projectRecommends[index].title,
                        jobState: projectRecommends[index].jobState,
                        location: projectRecommends[index].location,
                        description: projectRecommends[index].description,
                        personNeed: projectRecommends[index].personNeed,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

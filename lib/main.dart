import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/onboarding_screen.dart';
import 'package:go_great/submit_temp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter framework is ready

  // Access widgetsBinding correctly
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize SharedPreferences and Firebase
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app and remove the splash screen after rendering
  runApp(MyApp(onboardingCompleted));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  MyApp(this.onboardingCompleted);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'go_great', home: OnBoardingScreen());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = FirebaseDatabase.instanceFor(app: Firebase.app())
                                      .ref()
                                      .child('projects');
  late List<ProjectRecommend> projectRecommends = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }
void fetchProjects() {
  databaseReference.onValue.listen((event) {
    List<dynamic> projectsList = event.snapshot.value as List<dynamic>;
    projectRecommends = projectsList.map((projectData) {
      return ProjectRecommend(
        time: DateTime.parse(projectData['time']),
        title: projectData['title'],
        jobState: projectData['jobState'],
        location: projectData['location'],
        description: projectData['description'],
        personNeed: projectData['personNeed'],
      );
    }).toList();
    setState(() {});
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          text: 'Ameer.',
                          style: GoogleFonts.sourceSans3(
                              color: secondaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 20,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            SearchBar(),
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
              style: GoogleFonts.sourceSans3(fontSize: 14, color: grey),
            )
          ],
        ),
        SizedBox(height:18),
            Expanded(
               child: ListView.builder(
                  itemCount: projectRecommends.length,
                  itemBuilder: (context, index) {
                    return ProjectRecommend(
                      time: projectRecommends[index].time,
                      title: projectRecommends[index].title,
                      jobState: projectRecommends[index].jobState,
                      location: projectRecommends[index].location,
                      description: projectRecommends[index].description,
                      personNeed: projectRecommends[index].personNeed,
                    );
                  },
                ),
            ),
          ],
        ),
      )),
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
              MaterialPageRoute(builder: (context) => ProjectStoreScreen()),
            );
            },
          ),
          RecommendedCard(
              title: 'Lesson',
              subtitle: 'Find the lessons from the\nproject you have',
              bgColor: primaryColor,
              textColor: Colors.white,
              press: () {})
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
  });

  DateTime time;
  String title;
  String jobState;
  String location;
  String description;
  String personNeed;

  @override
  State<ProjectRecommend> createState() => _ProjectRecommendState();
}

class _ProjectRecommendState extends State<ProjectRecommend> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 24),
          width: MediaQuery.of(context).size.width*1,
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
              Text('Posted ${widget.time} ago', style: GoogleFonts.openSans(fontSize: 10, fontWeight: FontWeight.w400, color: grey),),
              SizedBox(height: 5,),
              Text(widget.title,
              textAlign: TextAlign.start, 
              style: GoogleFonts.sourceSans3(fontSize: 20, fontWeight: FontWeight.w700, color: primaryColor),),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/briefcase.svg'),
                  SizedBox(width: 5,),
                  Text(
                    widget.jobState,
                    style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w400, color: grey),

                  ),
                  SizedBox(width: 10,),
                  SvgPicture.asset('assets/location.svg'),
                  SizedBox(width: 5,),
                  Text(widget.location,
                  style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w400, color: grey),
                  )
                ],
              ),
              SizedBox(height: 5,),
              Text(
                widget.description,
                style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF5F5F5F)),
                overflow: TextOverflow.ellipsis,
                maxLines: 4, // adjust based on your needs
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/people.svg'),
                  SizedBox(width: 3,),
                  Text('5 to 10', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w400, color: grey),),
                  Expanded(child: SizedBox()),
                  SvgPicture.asset('assets/bookmark.svg')
                ],
              )

            ],
          ),
        )
      ],
    );
  }
}

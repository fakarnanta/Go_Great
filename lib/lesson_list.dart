import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/course_details.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonList extends StatefulWidget {
  const LessonList({super.key});

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  @override
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
                color: primaryColor,
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
                      child: SvgPicture.asset('assets/backbutton_yellow.svg'),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    'Lessons',
                    style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(
                    'Find the lessons from the\nproject you have',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 35,
                left: 120,
                child: Image.asset(
                  'assets/a2.png',
                  color: Color.fromARGB(255, 4, 43, 63),
                ))
          ]),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
            child: LessonListCard(
              title: 'AI Software Developer to develop Business Intelligence',
              finishedTime: DateTime.now(),
            ),
          )
        ],
      )),
    );
  }
}

class LessonListCard extends StatefulWidget {
  LessonListCard({
    Key? key,
    required this.title,
    required this.finishedTime,
  });

  String title;
  DateTime finishedTime;

  @override
  State<LessonListCard> createState() => _LessonListCardState();
}

class _LessonListCardState extends State<LessonListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 17, top: 20, right: 17, bottom: 20),
      width: MediaQuery.of(context).size.width * 1,
      height: 180,
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
            widget.title,
            style: GoogleFonts.sourceSans3(
                fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Finished Project: ${widget.finishedTime} ago',
            style: GoogleFonts.openSans(
                fontWeight: FontWeight.w400, fontSize: 12, color: grey),
          ),
          Expanded(child: SizedBox()),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseDetails(
                title: widget.title,
                projectTime: widget.finishedTime,
                location: '',
                contentHeader: 'Business Intelligence Understanding',
                content: 'Business Intelligence Understanding" can be translated to English as "Understanding Business Intelligence." In the context of information technology and management, Business Intelligence (BI) refers to the use of technologies, processes, and tools to analyze and present business information. It involves collecting, processing, and analyzing data to support business decision-making.\n\nSo, "Business Intelligence Understanding" in English would refer to the comprehension or knowledge of how Business Intelligence works, including the processes, technologies, and tools used to extract valuable insights from data to aid in business decision-making.',
              )),
            );
                  }, // Replace with your button's action
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFFFC34C), // Set the background color
                    minimumSize: Size(130, 42), // Set the width and height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(60), // Apply rounded corners
                    ),
                  ),
                  child: Text(
                    'Open Lessons', // Replace with your desired button text
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: primaryColor // Adjust text style as needed
                        ),
                  )))
        ],
      ),
    );
  }
}

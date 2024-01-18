import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/submission.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetail extends StatefulWidget {
  ProjectDetail({
    Key? key,
    required this.title,
    required this.jobState,
    required this.location,
    required this.description,
    required this.personNeed,
    this.projectLength,
    this.companyName,
    this.companySize,
  });

  String title;
  String jobState;
  String location;
  String description;
  String personNeed;
  String? projectLength;
  String? companyName;
  String? companySize;

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 90,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                   Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Submission(
                      companyName: widget.companyName ?? 'Unknown',
                      companySize: widget.companySize ?? 'Unknown',
                )),
              );
              },
              child: Container(
                width: 232,
                height: 52,
                decoration: ShapeDecoration(
                  color: Color(0xFF063F5C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(179),
                  ),
                ),
                child: Center(
                    child: Text(
                  'Apply Projects',
                  style: GoogleFonts.raleway(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: OvalBorder(),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.50,
                heightFactor: 0.50,
                child: SvgPicture.asset(
                  'assets/bookmark.svg',
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
                    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: 3.14159265, // Angle in radians for 180 degrees rotation
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset('assets/nextbutton.svg')),
              ),
              SizedBox(
                height: 20,
              ),
              Text(widget.title,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primaryColor)),
              SizedBox(
                height: 14,
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
                        fontSize: 13, fontWeight: FontWeight.w400, color: grey),
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
                        fontSize: 13, fontWeight: FontWeight.w400, color: grey),
                  )
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                widget.description,
                style: GoogleFonts.sourceSans3(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/calendar.png',
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.projectLength ??
                            'Unknown', // Use 'Unknown' as a default value if widget.projectLength is null
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Project Length',
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/people_company.svg'),
                  SizedBox(
                    width: 9,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.personNeed,
                        style: GoogleFonts.openSans(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Participants',
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'About The Company',
                style: GoogleFonts.sourceSans3(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: primaryColor),
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  Container(
                    width: 69,
                    height: 69,
                    decoration: ShapeDecoration(
                      color: Color(0xFF063F5C),
                      shape: OvalBorder(),
                    ),
                    child: Center(child: Image.asset('assets/business.png')),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.companyName ?? 'Unknown',
                        style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.companySize ?? 'Unknown',
                        style: GoogleFonts.openSans(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              )
            ],
                    ),
                  ),
          )),
    );
  }
}

class TagContainer extends StatelessWidget {
  const TagContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the list of tags (replace with your actual list)
    final List<String> tags = [/* your list of tags here */];

    // Determine the appropriate container based on the list size
    if (tags.isEmpty) {
      // Handle the case where there are no tags
      return const Center(child: Text('No tags to display'));
    } else if (tags.length == 1) {
      // Display a single tag
      return Container(
        width: 169,
        height: 30,
        decoration: ShapeDecoration(
          color: Color(0x7FF7AD1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(75),
          ),
        ),
        child: Center(
          child: Text(
            tags.first,
            style: GoogleFonts.openSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
      );
    } else {
      // Display multiple tags in a row or column
      return Wrap(
        spacing: 8.0, // Adjust spacing between tags
        children: tags
            .map((tag) => Chip(
                    label: Text(
                  tag,
                  style: GoogleFonts.openSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                )))
            .toList(),
        // Customize styling for multiple tags here
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chewie/chewie.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({
    required this.title,
    required this.projectTime,
    required this.location,
    this.videoUrl,
    this.contentHeader,
    this.content,
  });

  final String title;
  final DateTime projectTime;
  final String location;
  final String? videoUrl;
  final String? contentHeader;
  final String? content;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    final urlString =
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    final uri = Uri.parse(urlString);
    _controller = VideoPlayerController.networkUrl(uri);
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: true,
      );
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                             padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: ShapeDecoration(
                    color: Color(0xFF063F5C),
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
                          child:
                              SvgPicture.asset('assets/backbutton_yellow.svg'),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      VideoPlayerContainer(),
                      SizedBox(height: 16,),
                      Text(widget.title, style: GoogleFonts.sourceSans3(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),),
                      SizedBox(height: 10,),
                      Text('Finished ${widget.projectTime}ago', style: GoogleFonts.openSans(fontSize: 12, color: Colors.white),),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SvgPicture.asset('assets/location.svg'),
                          Text(widget.location, style: GoogleFonts.sourceSans3(fontSize: 16, color: Colors.white),)
                        ],
                      )                      
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
              child: Column(
                children: [
                  Text(widget.contentHeader ?? '', style: GoogleFonts.sourceSans3(fontSize: 24, fontWeight: FontWeight.w700), ),
                  SizedBox(height: 34,),
                  Text(widget.content ?? '', style: GoogleFonts.sourceSans3(fontSize: 16, fontWeight: FontWeight.w400),)
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class VideoPlayerContainer extends StatefulWidget {
  @override
  _VideoPlayerContainerState createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    final urlString =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
    final uri = Uri.parse(urlString);

    _videoController = VideoPlayerController.networkUrl(
      uri,
    )..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true); // Enable looping
          _videoController.play(); // Start playing the video
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Adjust the width as needed
      height: 200, // Adjust the height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: _videoController.value.isInitialized
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(25), // Set circular border radius
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            )
          :  Center(
                      child:
                      LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        secondRingColor: primaryColor,
                        thirdRingColor: secondaryColor,
                         size: 50)
                    ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}

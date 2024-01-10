import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class TutorialsScreen2 extends StatefulWidget {
  const TutorialsScreen2({Key? key}) : super(key: key);

  @override
  _FirestoreVideoDisplayState createState() => _FirestoreVideoDisplayState();
}

class _FirestoreVideoDisplayState extends State<TutorialsScreen2> {
  late List<FlickManager> _flickManagers = [];
  final storage = FirebaseStorage.instance;
  final videoName = [
    'PC Build Guide.mp4',
    'PC Build Guide 2.mp4',

  ];


  @override
  void initState() {
    super.initState();
    getVideoUrls();
  }

  Future<void> getVideoUrls() async {
    for (var videoName in videoName) {
      try {
        final Reference ref = storage.ref().child('video/$videoName');
        final String videoUrl = await ref.getDownloadURL();
        // Update the FlickManager with the new video URL
        FlickManager flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.network(videoUrl),
          autoPlay: false,
        );

        _flickManagers.add(flickManager);
        setState(() {});
      } catch (error) {
        print('Error getting video URL: $error');
      }
    }
  }


  @override
  void dispose() {
    for (var manager in _flickManagers) {
      manager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          'OCTAHUB',
          style: GoogleFonts.bebasNeue(
            color: Colors.amber,
            fontSize: 40,
            letterSpacing: 6,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _flickManagers.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300,
                    child: FlickVideoPlayer(
                      flickManager: _flickManagers[index],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),  // Add this line
                  child: Text(
                    'PC Build Guide- 0${index + 1}',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 33,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
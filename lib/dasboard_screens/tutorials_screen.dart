import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  _FirestoreVideoDisplayState createState() => _FirestoreVideoDisplayState();
}

class _FirestoreVideoDisplayState extends State<TutorialsScreen> {
  late List<FlickManager> _flickManagers = [];
  final storage = FirebaseStorage.instance;
  final videoName = [
    'DIY PC Build_EPISODE- 01.mp4',
    'DIY PC Build_EPISODE- 02.mp4',
    'DIY PC Build_EPISODE- 03.mp4',
    'DIY PC Build_EPISODE- 04.mp4',
    'DIY PC Build_EPISODE- 05.mp4',
    'DIY PC Build_EPISODE- 06.mp4',
    'DIY PC Build_EPISODE- 07.mp4',
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
                SizedBox(
                  height: 300,
                  child: FlickVideoPlayer(
                    flickManager: _flickManagers[index],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),  // Add this line
                  child: Text(
                    'DIY PC Build_EPISODE- 0${index + 1}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.amberAccent,
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
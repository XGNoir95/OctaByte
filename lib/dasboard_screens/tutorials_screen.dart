import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  State<TutorialsScreen> createState() => _YoutubePlayerExampleState();
}

class _YoutubePlayerExampleState extends State<TutorialsScreen> {
  final videoURL1 = "https://youtu.be/PfiQb8pca10?si=8vzq5MyT8uPt6nt1";
  final videoURL2 = "https://youtu.be/9WLjJWtA27s?si=nvGgMNA50Isu5d8R";
  final videoURL3 = "https://youtu.be/5TwzXdBIPDY?si=ZmuZVoPxmNuIGtLY";
  final videoURL4 = "https://youtu.be/zLIzyP6MMBA?si=jfu7-d7tk4WvTkB2";

  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  late YoutubePlayerController _controller3;
  late YoutubePlayerController _controller4;

  @override
  void initState() {
    final videoID1 = YoutubePlayer.convertUrlToId(videoURL1);
    final videoID2 = YoutubePlayer.convertUrlToId(videoURL2);
    final videoID3 = YoutubePlayer.convertUrlToId(videoURL3);
    final videoID4 = YoutubePlayer.convertUrlToId(videoURL4);

    _controller1 = YoutubePlayerController(
      initialVideoId: videoID1!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    _controller2 = YoutubePlayerController(
      initialVideoId: videoID2!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    _controller3 = YoutubePlayerController(
      initialVideoId: videoID3!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    _controller4 = YoutubePlayerController(
      initialVideoId: videoID4!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 210,
                ),
              ),
              buildVideoContainer(_controller1, "DIY PC Build | EPISODE- 01"),
              buildVideoContainer(_controller2, "DIY PC Build | EPISODE- 02"),
              buildVideoContainer(_controller3, "DIY PC Build | EPISODE- 03"),
              buildVideoContainer(_controller4, "DIY PC Build | EPISODE- 04"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildVideoContainer(YoutubePlayerController controller, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Colors.white,
                  handleColor: Colors.amberAccent,
                ),
              ),
              FullScreenButton(),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),
        ],
      ),
    );
  }
}

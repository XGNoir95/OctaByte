import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  State<TutorialsScreen> createState() => _YoutubePlayerExampleState();
}

class _YoutubePlayerExampleState extends State<TutorialsScreen> {
  final videoURL = "https://youtu.be/PfiQb8pca10?si=8vzq5MyT8uPt6nt1";
  final videoURL2 = "https://youtu.be/9WLjJWtA27s?si=nvGgMNA50Isu5d8R";

  late YoutubePlayerController _controller;
  late YoutubePlayerController _controller2;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    final videoID2 = YoutubePlayer.convertUrlToId(videoURL2);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0), // Adjust the spacing as needed
            child: YoutubePlayer(
              controller: _controller,
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
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0), // Adjust the spacing as needed
            child: YoutubePlayer(
              controller: _controller2,
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
          ),
        ],
      ),
    );
  }
}

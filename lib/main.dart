import 'package:flutter/material.dart';
import 'package:video/functions.dart';
import 'package:video/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:video/globals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(title: "video player"));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: VideoFuture,
              builder: (context, value, child) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: value == null
                      ? BlankScreen()
                      : FutureBuilder(
                          future: value,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return VideoPlayer(videoPlayerController);
                            } else {
                              return const Loadingwidget();
                            }
                          },
                        ),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: videos.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text('video ${index + 1}'),
                  subtitle: Text(videos[index]),
                  onTap: () => VideoFuture.value = play(videos[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

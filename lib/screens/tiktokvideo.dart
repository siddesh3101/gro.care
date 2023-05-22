import 'package:flutter/material.dart';
import 'package:tiktok/models/tiktok.dart';
import 'package:tiktok/widget/leftItems.dart';
import 'package:tiktok/widget/rightItems.dart';
import 'package:tiktok/widget/videoPlayer.dart';

class TikTokVideo extends StatelessWidget {
  final Posts data;

  const TikTokVideo({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TikTokVideoPlayer(url: data.submission!.mediaUrl),
          title(),
          RightItems(
            comments: "Hi",
            userImg: data.creator!.pic,
            favorite: 0,
            coverImg: data.creator!.pic,
          ),
          LeftItems(
            description: "Hi",
            musicName: "Hi",
            authorName: "Hi",
            userName: "Hi",
          )
        ],
      ),
    );
  }

  Widget title() => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 28.0),
          child: Text(
            "Trending | For You",
            style: TextStyle(color: Colors.white, fontSize: 19.0),
          ),
        ),
      );
}

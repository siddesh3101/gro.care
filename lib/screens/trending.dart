import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok/models/tiktok.dart';
import 'package:tiktok/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok/screens/tiktokvideo.dart';
import 'package:tiktok/services/video_service.dart';

class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  List<Posts> posts = [];
  int currentPage = 0;
  bool isLoading = false;
  PageController _pageController = PageController(initialPage: 0);

  ScrollController _scrollController = ScrollController();
  PagingController _pagingController = PagingController(firstPageKey: 0);
  RequestController api = RequestController();
  List<Widget> tikTokVideos = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<SharedPreferences> _prefs2;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _pageController.addListener(_scrollListener);
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pageController.offset >= _pageController.position.maxScrollExtent &&
        !_pageController.position.outOfRange) {
      if (!isLoading) {
        currentPage++;
        _fetchPosts();
      }
    }
  }

  void _fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Posts>? fetchedPosts =
          await VideoServices().getPosts(currentPage);
      setState(() {
        posts.addAll(fetchedPosts!);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error scenarios here
    }
  }

  // Future<List<dynamic>> getTrending(int page) async {
  //   // var cookies = await api.getCookie();
  //   // api.setCookie(cookies);
  //   try {
  //     var response = await http.get(
  //       Uri.parse(
  //           "https://internship-service.onrender.com/videos?page=${page}"),

  //       // headers: api.headers,
  //     );

  //     Video tiktok = Video.fromJson(jsonDecode(response.body));
  //     print(response.body);
  //     return tiktok.data!.posts!;
  //   } catch (ex) {
  //     print(ex);
  //     return [];
  //   }
  // }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var newItems;
      var isLastPage = true;
      final response = await VideoServices().getPosts(pageKey);
      print("wait");
      if (response != null && response.isNotEmpty) {
        newItems = response;
        print("calling");
        isLastPage = newItems!.length < 4;
      } else {
        newItems = [];
        isLastPage = true;
      }
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,

      itemCount: posts.length + 1, // +1 for the loading indicator
      itemBuilder: (context, index) {
        if (index < posts.length) {
          return TikTokVideo(data: posts[index]);
        } else {
          return Text('Hi');
        }
      },
      controller: _pageController,
    );
  }
}


// PageView(
//       scrollDirection: Axis.vertical,
//       controller: pageController,
//       children: tikTokVideos.length == 0
//           ? <Widget>[
//               Container(
//                 color: Colors.black,
//                 child: Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.amber,
//                   ),
//                 ),
//               )
//             ]
//           : tikTokVideos,
//     );

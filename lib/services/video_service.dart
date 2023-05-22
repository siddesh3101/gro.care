import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:tiktok/models/tiktok.dart';

class VideoServices {
  // late final _apiLink;
  late final Dio _dio;
  late final _timeNow;
  VideoServices() {
    // _apiLink = apiLink;
    _dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
        },
        baseUrl: "https://internship-service.onrender.com/",
        followRedirects: false,
        validateStatus: (status) {
          return (status ?? 200) < 500;
        },
      ),
    );
    _timeNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  Future<List<Posts>?> getPosts(int pagekey) async {
    final url =
        "https://internship-service.onrender.com/videos?page=${pagekey}";
    print(url);
    Response response = await _dio.get(
      'videos?page=${pagekey}',
    );
    if (response.statusCode == 200) {
      Video tiktokVidep = Video.fromJson(response.data);
      if (tiktokVidep.data!.posts != null) {
        return tiktokVidep.data!.posts;
      }
    }
  }
}

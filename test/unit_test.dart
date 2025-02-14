// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

void main() {
  group(
    "VideoModel",
    () {
      test(
        "constructor",
        () {
          final video = VideoModel(
            id: "id",
            creatorUid: "creatorUid",
            creator: "creator",
            title: "title",
            description: "description",
            fileUrl: "fileUrl",
            thumbnailUrl: "thumbnailUrl",
            likes: 0,
            comments: 0,
            createdAt: 0,
          );
          expect(video.id, "id");
        },
      );

      test(
        ".fromJson constructor",
        () {
          final video = VideoModel.fromJson(
            json: {
              "id": "id",
              "creatorUid": "creatorUid",
              "creator": "creator",
              "title": "title",
              "description": "description",
              "fileUrl": "fileUrl",
              "thumbnailUrl": "thumbnailUrl",
              "likes": 0,
              "comments": 0,
              "createdAt": 0,
            },
            videoId: "videoId",
          );
          expect(video.title, "title");
          expect(video.comments, isInstanceOf<int>());
        },
      );

      test(
        ".toJson constructor",
        () {
          final video = VideoModel(
            id: "id",
            creatorUid: "creatorUid",
            creator: "creator",
            title: "title",
            description: "description",
            fileUrl: "fileUrl",
            thumbnailUrl: "thumbnailUrl",
            likes: 0,
            comments: 0,
            createdAt: 0,
          ).toJson();
          expect(video["id"], "id");
          expect(video["likes"], isInstanceOf<int>());
        },
      );
    },
  );
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepo {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/video/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video, SettableMetadata(contentType: "video/mp4"));
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    final query = _db.collection("likes").doc("$videoId-000-$userId");
    final like = await query.get();
    if (!like.exists) {
      await query.set({"createdAt": DateTime.now().millisecondsSinceEpoch});
    } else {
      await query.delete();
    }
  }

  Future<bool> isLiked(String videoId, String userId) async {
    final query = _db
        .collection("users")
        .doc(userId)
        .collection("likedVideos")
        .doc(videoId);
    final like = await query.get();
    return like.exists;
  }
}

final videosRepo = Provider((ref) => VideosRepo());

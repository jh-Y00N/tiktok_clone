import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<UserProfileModel>> getUsers() async {
    final snapshot = await _db.collection("users").get();
    return snapshot.docs
        .map((e) => UserProfileModel.fromJson(e.data()))
        .toList();
  }
}

final usersRepo = Provider(
  (ref) => UsersRepo(),
);

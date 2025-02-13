import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/repos/users_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserListViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late UsersRepo _repository;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _repository = ref.read(usersRepo);
    List<UserProfileModel> users = await _repository.getUsers();
    users = users
        .where(
          (element) => element.uid != ref.read(authRepo).user!.uid,
        )
        .toList();
    return users;
  }
}

final userListProvider =
    AsyncNotifierProvider<UserListViewModel, List<UserProfileModel>>(
  () => UserListViewModel(),
);

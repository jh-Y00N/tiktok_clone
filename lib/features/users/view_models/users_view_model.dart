import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepo _authRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authRepository = ref.read(authRepo);

    if (_authRepository.isLoggedIn) {
      final profile =
          await _usersRepository.findProfile(_authRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential, String birthday) async {
    if (credential.user == null) throw Exception("Account not created");

    state = AsyncValue.loading();
    final profile = UserProfileModel(
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anonymous",
      email: credential.user!.email ?? "Anonymous",
      hasAvatar: false,
      birthday: DateFormat.yMMMd().format(DateTime.parse(birthday)),
      bio: "undefined",
      link: "undefined",
    );
    await _usersRepository.createProfile(profile);
    await _usersRepository.setBirthday(profile.uid, birthday);
    state = AsyncValue.data(
      profile,
    );
  }

  Future<void> setBirthday(String uid, String date) async {
    final userJson = await _usersRepository.findProfile(uid);
    if (userJson == null) throw Exception("cannot find user.");

    state = AsyncValue.loading();
    await _usersRepository.setBirthday(uid, date);
  }

  Future<void> onAvatarUpload() async {
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> setBio(String uid, String bio) async {
    state = AsyncValue.data(state.value!.copyWith(bio: bio));
    await _usersRepository.updateUser(state.value!.uid, {"bio": bio});
  }

  Future<void> setLink(String uid, String link) async {
    state = AsyncValue.data(state.value!.copyWith(link: link));
    await _usersRepository.updateUser(state.value!.uid, {"link": link});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

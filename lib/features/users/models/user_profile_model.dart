class UserProfileModel {
  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.hasAvatar,
    required this.birthday,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : uid = "",
        name = "",
        email = "",
        hasAvatar = false,
        birthday = "",
        bio = "",
        link = "";

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    bool? hasAvatar,
    String? birthday,
    String? bio,
    String? link,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      birthday: birthday ?? this.birthday,
      bio: bio ?? this.bio,
      link: link ?? this.link,
    );
  }

  final String uid;
  final String name;
  final String email;
  final bool hasAvatar;
  late final String birthday;
  final String bio;
  final String link;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        email = json["email"],
        hasAvatar = json["hasAvatar"],
        birthday = json["birthday"],
        bio = json["bio"],
        link = json["link"];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "hasAvatar": hasAvatar,
      "birthday": birthday,
      "bio": bio,
      "link": link,
    };
  }
}

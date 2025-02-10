class VideoModel {
  VideoModel({
    required this.id,
    required this.creatorUid,
    required this.creator,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  final String id;
  final String creatorUid;
  final String creator;
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final int likes;
  final int comments;
  final int createdAt;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creatorUid": creatorUid,
      "creator": creator,
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
    };
  }

  VideoModel.fromJson(
      {required Map<String, dynamic> json, required String videoId})
      : id = videoId,
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"];
}

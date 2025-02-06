class VideoModel {
  VideoModel({
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
}

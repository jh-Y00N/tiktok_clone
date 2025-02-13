class MessageModel {
  MessageModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  String text;
  final String userId;
  final int createdAt;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
    };
  }

  MessageModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json["id"],
        text = json["text"],
        userId = json["userId"],
        createdAt = json["createdAt"];
}

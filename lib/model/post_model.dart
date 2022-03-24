class Post {
  String? uid;
  String? fullName;
  String? img_user;
  String? id;
  String img_post;
  String caption;
  String? date;
  bool liked = false;

  bool mine = false;

  Post(
      {required this.img_post,
      required this.caption,
      this.uid,
      this.fullName,
      this.img_user,
      this.id,
      this.date});

  Post.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        fullName = json["fullName"],
        img_user = json["img_user"],
        id = json["id"],
        img_post = json["img_post"],
        caption = json["caption"],
        date = json["date"],
        liked = json["liked"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "img_user": img_user,
        "id": id,
        "img_post": img_post,
        "caption": caption,
        "date": date,
        "liked": liked
      };
}

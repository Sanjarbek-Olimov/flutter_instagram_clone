class UserModel {
  String uid;
  String fullName;
  String email;
  String password;
  String img_url;

  bool followed = false;
  int followers = 0;
  int followings = 0;

  UserModel(
      {required this.fullName,
      required this.email,
      this.uid = "",
      required this.password,
      this.img_url = ""});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        fullName = json["fullName"],
        email = json["email"],
        password = json["password"],
        img_url = json["img_url"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "email": email,
        "password": password,
        "img_url": img_url
      };

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return other is UserModel && other.uid == uid;
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/model/user_model.dart';
import 'package:flutter_instagram/services/auth_service.dart';
import 'package:flutter_instagram/services/data_service.dart';
import 'package:flutter_instagram/services/file_service.dart';
import 'package:flutter_instagram/services/utils_service.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = false;
  List<Post> items = [];
  int axisCount = 1;
  File? _image;
  String fullName = "";
  String email = "";
  String img_url = "";
  int count_post = 0;
  int followers = 0;
  int following = 0;

  void _apiLoadUser() {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser(null).then((value) => _showUserInfo(value));
  }

  void _showUserInfo(UserModel userModel) {
    setState(() {
      fullName = userModel.fullName;
      email = userModel.email;
      img_url = userModel.img_url;
      followers = userModel.followers;
      following = userModel.followings;
      isLoading = false;
    });
  }

  void _apiChangePhoto() {
    if (_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image!)
        .then((downLoadUrl) => _apiUpdateUser(downLoadUrl!));
  }

  void _apiUpdateUser(String downLoadUrl) async {
    UserModel userModel = await DataService.loadUser(null);
    userModel.img_url = downLoadUrl;
    await DataService.updateUser(userModel);
    _apiLoadUser();
  }

  void  _apiLoadPost() {
    setState(() {
      isLoading = true;
    });
    DataService.loadPosts(null).then((value) => {_resLoadPosts(value)});
  }

  void _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_post = items.length;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadUser();
    _apiLoadPost();
  }

  _imgFromGalleryCamera(source) async {
    XFile? image =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    _imgFromGalleryCamera(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Pick Photo"),
                ),
                ListTile(
                  onTap: () {
                    _imgFromGalleryCamera(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take Photo"),
                ),
              ],
            ),
          );
        });
  }

  void _actionLogOut() async {
    var result = await Utils.dialogCommon(
        context, "Insta Clone", "Do you want to log out?", false);
    if (result) AuthService.signOutUser(context);
  }

  void _actionRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Insta Clone", "Do you want to remove this post?", false);
    if (result) {
      setState(() {
        isLoading = true;
      });
      DataService.removePost(post).then((value) => {_apiLoadPost()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: "Bluevinyl"),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: _actionLogOut,
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Color.fromRGBO(193, 53, 132, 1),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  // #myphoto
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(193, 53, 132, 1))),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: img_url == ""
                                ? Image.asset(
                                    "assets/images/img.png",
                                    width: 70,
                                    height: 70,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: img_url,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: bottomSheet,
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.purple,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  // #myinfos
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    fullName.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),

                  // #mycounts
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                count_post.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "POSTS",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        )),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        Expanded(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                followers.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "FOLLOWERS",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        )),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        Expanded(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                following.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "FOLLOWING",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  // #gridselect
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: IconButton(
                          onPressed: () {
                            setState(() {
                              axisCount = 1;
                            });
                          },
                          icon: const Icon(
                            Icons.list_alt,
                            size: 27,
                          ),
                        ))),
                        Expanded(
                            child: Center(
                                child: IconButton(
                          onPressed: () {
                            setState(() {
                              axisCount = 2;
                            });
                          },
                          icon: const Icon(
                            Icons.grid_view,
                            size: 27,
                          ),
                        ))),
                      ],
                    ),
                  ),

                  Expanded(
                      child: GridView.builder(
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: axisCount),
                          itemBuilder: (context, index) {
                            return _itemOfPost(items[index]);
                          }))
                ],
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : const SizedBox.shrink()
          ],
        ));
  }

  Widget _itemOfPost(Post post) {
    return GestureDetector(
      onLongPress: () {
        _actionRemovePost(post);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: post.img_post,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              post.caption,
              style: TextStyle(color: Colors.black87.withOpacity(0.7)),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}

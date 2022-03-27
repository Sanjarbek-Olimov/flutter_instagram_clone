import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/model/user_model.dart';
import 'package:flutter_instagram/services/data_service.dart';

class OtherProfilePage extends StatefulWidget {
  String uid;
  OtherProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  bool isLoading = false;
  int axisCount = 1;
  String fullName = "";
  String email = "";
  String img_url = "";
  int count_post = 0;
  int followers = 0;
  int following = 0;
  List<Post> items = [];

  void  _apiLoadUser() {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser(widget.uid).then((value) => {_resLoadUser(value)});
  }

  void _resLoadUser(UserModel userModel) {
    setState(() {
      fullName = userModel.fullName;
      email = userModel.email;
      img_url = userModel.img_url;
      followers = userModel.followers;
      following = userModel.followings;
      _apiLoadPost();
    });
  }

  void  _apiLoadPost() {
    setState(() {
      isLoading = true;
    });
    DataService.loadPosts(widget.uid).then((value) => {_resLoadPosts(value)});
  }

  void _resLoadPosts(List<Post> posts) {
    setState(() {
      count_post = posts.length;
      items = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadUser();
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
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(193, 53, 132, 1),
              )),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  // #photo
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

                  // #infos
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

                  // #counts
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
    return Container(
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
    );
  }
}

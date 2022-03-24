import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/services/data_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFeedPage extends StatefulWidget {
  PageController pageController;

  MyFeedPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadFeeds() {
    DataService.loadFeeds().then((value) => {_resLoadFeeds(value)});
  }

  void _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnlike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Instagram",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: "Bluevinyl"),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  widget.pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Color.fromRGBO(193, 53, 132, 1),
                ))
          ],
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _itemOfPost(items[index]);
            }));
  }

  Widget _itemOfPost(Post post) {
    return Column(
      children: [
        const Divider(),

        // #userinfo
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: post.img_user!.isEmpty || post.img_user == null
                    ? Image.asset(
                        "assets/images/img.png",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: post.img_user!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover),
              ),
              title: Text(
                post.fullName!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
              subtitle: Text(
                post.date!,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 13),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
              ),
            )),

        // #image
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          imageUrl: post.img_post,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator.adaptive()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),

        // #likeshare
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (!post.liked) {
                        _apiPostLike(post);
                      } else {
                        _apiPostUnlike(post);
                      }
                    },
                    icon: post.liked
                        ? const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                          )
                        : const FaIcon(FontAwesomeIcons.heart)),
                IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      Icons.share_outlined,
                    )),
              ],
            )
          ],
        ),

        // #caption
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(children: [
              TextSpan(
                  text: post.caption,
                  style: const TextStyle(color: Colors.black))
            ]),
          ),
        )
      ],
    );
  }
}

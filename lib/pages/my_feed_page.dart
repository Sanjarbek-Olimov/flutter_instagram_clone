import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFeedPage extends StatefulWidget {
  PageController pageController;

  MyFeedPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<Post> items = [];
  String post_img1 =
      "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964";
  String post_img2 =
      "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Post(
        postImage: post_img1,
        caption: "Discover more great images on our sponsor's site"));
    items.add(Post(
        postImage: post_img2,
        caption: "Discover more great images on our sponsor's site"));
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
                  color: Colors.black,
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
                child: Image.asset(
                  "assets/images/img.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                "Username",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
              subtitle: const Text(
                "March 15, 2022",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
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
          imageUrl: post.postImage,
          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        // #likeshare
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.heart)),
                IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.solidPaperPlane,
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

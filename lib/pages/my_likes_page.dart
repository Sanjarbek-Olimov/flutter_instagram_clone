import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/services/data_service.dart';
import 'package:flutter_instagram/services/utils_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'other_profile_page.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DataService.loadLikes().then((value) => {_resLoadLikes(value)});
  }

  void _resLoadLikes(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnlike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false).then((value) => {_apiLoadLikes()});
  }

  void _actionRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Insta Clone", "Do you want to remove this post?", false);
    if (result) {
      setState(() {
        isLoading = true;
      });
      DataService.removePost(post).then((value) => {_apiLoadLikes()});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Likes",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: "Bluevinyl"),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            items.isEmpty
                ? const Center(
                    child: Text("No liked posts"),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _itemOfPost(items[index]);
                    }),
            isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : const SizedBox.shrink()
          ],
        ));
  }

  Widget _itemOfPost(Post post) {
    return Column(
      children: [
        const Divider(),

        // #userinfo
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              onTap: (){
                if (!post.mine) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherProfilePage(uid: post.uid!)));
                }
              },
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: post.img_user!.isEmpty || post.img_user == null
                    ? Image.asset(
                        "assets/images/background.png",
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
              trailing: post.mine
                  ? IconButton(
                      onPressed: () {
                        _actionRemovePost(post);
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.black,
                      ))
                  : const SizedBox.shrink(),
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
                      if (post.liked) {
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
                    onPressed: () {
                      _fileShare(post);
                    },
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
  void _fileShare(Post post) async {
    setState(() {
      isLoading = true;
    });
    final box = context.findRenderObject() as RenderBox?;
    if (Platform.isAndroid || Platform.isIOS) {
      var response = await get(Uri.parse(post.img_post));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      Share.shareFiles([File('$documentDirectory/flutter.png').path],
          subject: 'Instagram',
          text: post.caption,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    setState(() {
      isLoading = false;
    });
  }
}

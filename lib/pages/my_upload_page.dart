import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/services/data_service.dart';
import 'package:flutter_instagram/services/file_service.dart';
import 'package:image_picker/image_picker.dart';

class MyUploadPage extends StatefulWidget {
  PageController pageController;

  MyUploadPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  bool isLoading = false;
  TextEditingController captionController = TextEditingController();
  File? _image;

  _imgFromGalleryCamera(source) async {
    XFile? image =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }

  _uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty) return;
    if (_image == null) return;
    _apiPostImage();
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(_image)
        .then((downloadUrl) => {_resPostImage(downloadUrl!)});
  }

  void _resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    Post post = Post(caption: caption, img_post: downloadUrl);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    Post posted = await DataService.storePost(post);
    DataService.storeFeed(posted).then((value) => {_moveToFeed()});
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
      _image = null;
      captionController.clear();
    });
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Upload",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "Bluevinyl"),
        ),
        actions: [
          IconButton(
              onPressed: _uploadNewPost,
              icon: const Icon(
                Icons.drive_folder_upload,
                color: Color.fromRGBO(193, 53, 132, 1),
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                GestureDetector(
                  onTap: bottomSheet,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.4),
                    child: _image == null
                        ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : Stack(
                            children: [
                              Image.file(
                                _image!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.black12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      icon: const Icon(Icons.highlight_remove),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextField(
                    controller: captionController,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(193, 53, 132, 1),
                          ),
                        ),
                        hintText: "Caption",
                        hintStyle:
                            TextStyle(fontSize: 17, color: Colors.black38)),
                  ),
                )
              ],
            ),
          )),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

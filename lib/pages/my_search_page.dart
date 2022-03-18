import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/user_model.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<UserModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Search",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: "Bluevinyl"),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [

              // #searchuser
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7)),
                height: 45,
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: searchController,
                  onChanged: (input) {
                    print(input);
                  },
                  decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _itemOfUser(items[index]);
                      }))
            ],
          ),
        ));
  }

  Widget _itemOfUser(UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          border: Border.all(
            width: 1.5,
            color: const Color.fromRGBO(193, 53, 132, 1)
          )
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.5),
          child: Image.asset("assets/images/img.png", width: 45, height: 45, fit: BoxFit.cover,),
        ),
      ),
      title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(user.email, style: const TextStyle(color: Colors.black54), softWrap: true, overflow: TextOverflow.ellipsis,),
      trailing: Container(
        alignment: Alignment.center,
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(3)
        ),
        child: Text("Follow"),
      ),
    );
  }
}

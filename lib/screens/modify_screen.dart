import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pidi/models/item.dart';
import 'package:pidi/models/posts.dart';
import 'package:pidi/screens/list_screen.dart';
import 'package:pidi/widgets/custom_dialog.dart';

import '../constants.dart';

class ModifyScreen extends StatefulWidget {
  final Item post;
  const ModifyScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  Widget item(i) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 5.0),
      child: SizedBox(
        child: ClipRRect(
            borderRadius: kBorderRadius,
            child: Image.network(widget.post.images[i].toString(),
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _buildImages() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.post.images.length,
      itemBuilder: (context, i) {
        return item(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Item rePost = Item(
        id: widget.post.id,
        date: widget.post.date,
        title: widget.post.title,
        content: widget.post.content,
        images: widget.post.images);
    var title_controller = TextEditingController();
    title_controller.text = widget.post.title;

    var contents_controller = TextEditingController();
    contents_controller.text = widget.post.content;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
            color: kBlack,
            onPressed: () {
              showDialog(
                  builder: (BuildContext context) {
                    return customDialog(
                        context, '취소', '변경사항이 저장되지 않았습니다.\n취소하시겠습니까?', '확인',
                        () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                  context: context);
            }),
        title: Text(DateFormat('yyyy-MM-dd').format(widget.post.date),
            style: TextStyle(color: kBlack, fontSize: kContentM)),
        actions: [
          // 아이콘 변경
          IconButton(
              icon: const Icon(Icons.check_rounded, size: 22),
              color: kBlack,
              onPressed: () {
                showDialog(
                    builder: (BuildContext context) {
                      return customDialog(
                          context, '수정', '수정사항을 저장하시겠습니까?', '저장', () {
                        updatePost(
                          widget.post.id,
                          title_controller.text,
                          contents_controller.text,
                        );
                      });
                    },
                    context: context);
              }),
        ],
        elevation: 0,
        backgroundColor: kWhite,
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     stops: const [
                //       0.65,
                //       0.35,
                //     ],
                //     colors: [
                //       kWhite,
                //       kUnderline,
                //     ],
                //   ),
                // ),
                child: Row(
                  children: [
                    Text(
                      '제목: ',
                      style: TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: kTitle),
                    ),
                    Expanded(
                      child: TextField(
                        controller: title_controller,
                        onChanged: (text) {
                          rePost.title = title_controller.text;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          isCollapsed: true,
                          counterText: "",
                        ),
                        maxLines: 1,
                        maxLength: 20,
                        style: TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: kTitle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(flex: 1, child: _buildImages()),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.topLeft,
                  child: Container(
                      decoration: const BoxDecoration(),
                      child: RawScrollbar(
                        thumbColor: kUnderline,
                        radius: const Radius.circular(20),
                        child: TextField(
                            controller: contents_controller,
                            autofocus: true,
                            onChanged: (text) {
                              rePost.content = text;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              isCollapsed: true,
                              counterText: "",
                            ),
                            maxLines: 7,
                            maxLength: 200,
                            style: TextStyle(
                              height: 2,
                              fontSize: kContentM,
                            )),
                      ))),
            ),
          ])),
    );
  }
}

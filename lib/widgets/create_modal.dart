import 'package:flutter/material.dart';

import '../constants.dart';

class CreateModal extends StatefulWidget {
  const CreateModal({Key? key}) : super(key: key);

  @override
  State<CreateModal> createState() => _CreateModalState();
}

class _CreateModalState extends State<CreateModal> {
  final int maxTitleLength = 20;
  final int maxContentLength = 200;
  String titleValue = "";
  String contentValue = "";

  @override
  Widget build(BuildContext context) {
    final List<String> images = <String>['0', '1', '2', '3'];
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    Widget item(i) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          width: 90,
          height: 90,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.asset('./assets/images/img${images[i]}.jpg',
                  fit: BoxFit.fill)),
        ),
      );
    }

    Widget _buildImages() {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, i) {
          return item(i);
        },
      );
    }

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Stack(
        children: [
          Container(
              width: 320,
              margin: EdgeInsets.only(
                left: 40,
                right: 40,
                top: isKeyboardShowing ? 50 : 190,
                bottom: isKeyboardShowing ? 0 : 190,
              ),
              decoration: BoxDecoration(
                color: kWhite,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close_rounded)),
                          )),
                      Expanded(flex: 3, child: _buildImages()),
                      Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Stack(children: [
                                      TextField(
                                          maxLines: 1,
                                          maxLength: maxTitleLength,
                                          onChanged: (value) {
                                            setState(() {
                                              titleValue = value;
                                            });
                                          },
                                          cursorColor: kBlack,
                                          decoration: InputDecoration(
                                            hintText: "제목을 입력하세요",
                                            counterText: "",
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: kGrey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                            ),
                                          )),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          width: 60,
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "${titleValue.length}/$maxTitleLength자",
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ])),
                                Expanded(
                                    flex: 6,
                                    child: Stack(children: [
                                      TextField(
                                          maxLines: 7,
                                          maxLength: maxContentLength,
                                          onChanged: (value) {
                                            setState(() {
                                              contentValue = value;
                                            });
                                          },
                                          cursorColor: kBlack,
                                          decoration: InputDecoration(
                                            hintText: "내용을 입력하세요",
                                            counterText: "",
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: kGrey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                            ),
                                          )),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          width: 100,
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "${contentValue.length}/$maxContentLength자",
                                            textAlign: TextAlign.right,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ]))
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  kUnderline)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("취소",
                                          style: TextStyle(
                                              color: kGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  kUnderline)),
                                      onPressed: () {},
                                      child: Text("저장",
                                          style: TextStyle(
                                              color: kBlack,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)))),
                            ],
                          ))
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

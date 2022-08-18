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
    final List<String> images = <String>['0', '1'];
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    Widget uploadImage() {
      return SizedBox(
        width: 80,
        height: 80,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            primary: kGrey,
            shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
            side: BorderSide(color: kGrey),
          ),
          child: Icon(
            Icons.add_rounded,
            color: kGrey,
            size: 26,
          ),
        ),
      );
    }

    Widget item(i) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 6.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: ClipRRect(
              borderRadius: kBorderRadius,
              child: Image.asset('./assets/images/img${images[i]}.jpg',
                  fit: BoxFit.cover)),
        ),
      );
    }

    Widget _buildImages() {
      if (images.isEmpty) {
        return Align(alignment: Alignment.centerLeft, child: uploadImage());
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, i) {
          if (i == images.length - 1) {
            return Row(
              children: [
                item(i),
                images.length == 5 ? Container() : uploadImage()
              ],
            );
          }
          return item(i);
        },
      );
    }

    Widget customTextField(maxLines, maxLength, value, hint, onChange) {
      return Stack(children: [
        TextField(
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChange,
            cursorColor: kBlack,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: kContentM, color: kGrey),
              counterText: "",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: kBorderRadiusS,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrey),
                borderRadius: kBorderRadiusS,
              ),
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 80,
            height: maxLines == 1 ? 50 : 168,
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${value.length}/$maxLength자",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: kSubText),
              ),
            ),
          ),
        ),
      ]);
    }

    Widget customTextButton(text, color, onPressed) {
      return Expanded(
          child: TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(kUnderline)),
              onPressed: onPressed,
              child: Text(text,
                  style: TextStyle(
                      color: color,
                      fontSize: kTitle,
                      fontWeight: FontWeight.bold))));
    }

    return Center(
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: Stack(
          children: [
            const SizedBox(
                width: 320,
                child: Image(image: AssetImage('./assets/images/topper.png'))),
            Container(
                width: 320,
                height: 480,
                alignment: Alignment.bottomCenter,
                child: const Image(
                    image: AssetImage('./assets/images/footer.png'))),
            Container(
                width: 320,
                height: 440,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close_rounded)),
                            )),
                        Expanded(flex: 8, child: _buildImages()),
                        Expanded(
                            flex: 24,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: customTextField(1, maxTitleLength,
                                      titleValue, "제목을 입력하세요", (v) {
                                    setState(() {
                                      titleValue = v;
                                    });
                                  }),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: customTextField(7, maxContentLength,
                                      contentValue, "내용을 입력하세요", (v) {
                                    setState(() {
                                      contentValue = v;
                                    });
                                  }),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                customTextButton('취소', kGrey, () {
                                  Navigator.pop(context);
                                }),
                                customTextButton('저장', kBlack, () {})
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

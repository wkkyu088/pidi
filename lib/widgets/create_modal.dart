import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pidi/models/posts.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../constants.dart';

class CreateModal extends StatefulWidget {
  final DateTime selectedDate;
  const CreateModal({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<CreateModal> createState() => _CreateModalState();
}

class _CreateModalState extends State<CreateModal> {
  final int maxTitleLength = 20;
  final int maxContentLength = 200;
  String titleValue = "";
  String contentValue = "";
  bool isTodayDone = false;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.selectedDate;
  }

  final ImagePicker picker = ImagePicker();
  List<XFile?> _pickedImages = [];

  Future getImage(ImageSource imageSource) async {
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      if (images.length > 5) {
        _pickedImages = images.sublist(0, 5);
        Fluttertoast.showToast(msg: "최대 5장까지 등록 가능합니다.");
      } else {
        _pickedImages = images;
      }
    });
  }

  Widget uploadImage(onPressed) {
    return SizedBox(
      width: 70,
      height: 70,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: kGrey,
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

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    double w = mediaQueryData.size.width * 0.8;
    final keyboardHeight = mediaQueryData.viewInsets.bottom;

    List<DateTime> deactivateDates = [];

    for (var v in postList) {
      deactivateDates.add(v.date);
      if (kToday.difference(v.date).inDays == 0) {
        setState(() {
          isTodayDone = true;
        });
        print(isTodayDone);
      }
    }

    Widget item(i) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 6.0),
        child: SizedBox(
            width: 75,
            height: 75,
            child: Container(
              decoration: i <= _pickedImages.length - 1
                  ? BoxDecoration(
                      borderRadius: kBorderRadius,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(_pickedImages[i]!.path))))
                  : null,
            )),
      );
    }

    Widget _buildImages(onPressed) {
      if (_pickedImages.isEmpty) {
        return Align(
            alignment: Alignment.centerLeft, child: uploadImage(onPressed));
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        itemCount: _pickedImages.length,
        itemBuilder: (context, i) {
          if (i == _pickedImages.length - 1) {
            return Row(
              children: [
                item(i),
                _pickedImages.length >= 5 ? Container() : uploadImage(onPressed)
              ],
            );
          }
          return item(i);
        },
      );
    }

    Widget customTextField(maxLines, maxLength, value, hint, onChange) {
      return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          TextField(
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChange,
            style: TextStyle(fontSize: kContentM, color: kBlack),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: kContentM, color: kGrey),
              counterText: "",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: kBorderRadiusS,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrey),
                borderRadius: kBorderRadiusS,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '${value.length}/$maxLength자',
              style: TextStyle(fontSize: kSubText, color: kGrey),
            ),
          ),
        ],
      );
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
      child: Container(
        margin: EdgeInsets.only(
            bottom: keyboardHeight > 0
                ? mediaQueryData.size.height * 0.145 + keyboardHeight * 0.4
                : mediaQueryData.size.height * 0.2),
        child: Column(
          children: [
            SizedBox(
                width: w,
                child: const Image(
                    image: AssetImage('./assets/images/topper.png'))),
            // 0. 배경 컨테이너
            Container(
              width: w,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. 데이트 피커
                      TextButton(
                        onPressed: (() async {
                          DateTime? newDateTime = await showRoundedDatePicker(
                              context: context,
                              height: mediaQueryData.size.height * 0.43,
                              initialDate: dateTime,
                              firstDate: kFirstDay,
                              lastDate: kToday,
                              borderRadius: 8,
                              listDateDisabled: deactivateDates,
                              theme: ThemeData(
                                  primaryColor: kBackground,
                                  colorScheme: ColorScheme(
                                    brightness: Brightness.light,
                                    primary: kBlack,
                                    onPrimary: kBlack,
                                    secondary: kGrey,
                                    onSecondary: kGrey,
                                    error: kPoint,
                                    onError: kPoint,
                                    background: kWhite,
                                    onBackground: kWhite,
                                    surface: kBlack,
                                    onSurface: kBlack,
                                  ),
                                  fontFamily: fontFamily),
                              styleDatePicker: MaterialRoundedDatePickerStyle(
                                textStyleDayButton:
                                    TextStyle(fontSize: kTitle, color: kBlack),
                                textStyleYearButton: TextStyle(
                                    fontSize: kContentM, color: kBlack),
                                textStyleDayHeader: TextStyle(
                                    fontSize: kContentM, color: kBlack),
                                textStyleCurrentDayOnCalendar: TextStyle(
                                    fontSize: kContentM,
                                    color: kPoint,
                                    fontWeight: FontWeight.bold),
                                textStyleDayOnCalendar: TextStyle(
                                    fontSize: kContentM, color: kBlack),
                                textStyleDayOnCalendarSelected: TextStyle(
                                    fontSize: kContentM,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textStyleDayOnCalendarDisabled: TextStyle(
                                    fontSize: kTitle,
                                    color: kBlack.withOpacity(0.1)),
                                textStyleMonthYearHeader: TextStyle(
                                    fontSize: kContentM + 1,
                                    color: kBlack,
                                    fontWeight: FontWeight.bold),
                                paddingDatePicker: const EdgeInsets.all(8),
                                paddingMonthHeader: const EdgeInsets.all(16),
                                sizeArrow: 22,
                                colorArrowNext: kBlack,
                                colorArrowPrevious: kBlack,
                                marginTopArrowPrevious: 8,
                                marginLeftArrowPrevious: 8,
                                marginTopArrowNext: 8,
                                marginRightArrowNext: 16,
                                textStyleButtonAction: TextStyle(
                                    fontSize: kContentM, color: kBlack),
                                textStyleButtonPositive: TextStyle(
                                    fontSize: kContentM,
                                    color: kBlack,
                                    fontWeight: FontWeight.bold),
                                textStyleButtonNegative: TextStyle(
                                    fontSize: kContentM,
                                    color: kBlack.withOpacity(0.5)),
                                decorationDateSelected: BoxDecoration(
                                    color: kBlack, shape: BoxShape.circle),
                                backgroundPicker: Colors.white,
                                backgroundActionBar: Colors.white,
                                backgroundHeaderMonth: Colors.white,
                              ),
                              styleYearPicker: MaterialRoundedYearPickerStyle(
                                textStyleYear: TextStyle(
                                    fontSize: kContentM, color: kBlack),
                                textStyleYearSelected: TextStyle(
                                    fontSize: kAppBar,
                                    color: kBlack,
                                    fontWeight: FontWeight.bold),
                                heightYearRow: 50,
                                backgroundPicker: Colors.white,
                              ));
                          if (newDateTime != null) {
                            setState(() {
                              dateTime = newDateTime;
                              print(dateTime);
                            });
                          }
                        }),
                        style: TextButton.styleFrom(foregroundColor: kGrey),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                DateFormat('yyyy-MM-dd EE', 'ko-KR')
                                    .format(dateTime!),
                                style: TextStyle(
                                    color: kBlack.withOpacity(0.8),
                                    fontSize: kContentS + 1)),
                            const SizedBox(width: 3),
                            Icon(Icons.edit_rounded,
                                size: 15, color: kBlack.withOpacity(0.6))
                          ],
                        ),
                      ),
                      // 2. 이미지 리스트
                      Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _buildImages(() {
                            getImage(ImageSource.gallery);
                          })),
                      // 3. 텍스트 필드
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: customTextField(
                            1, maxTitleLength, titleValue, "제목을 입력하세요", (v) {
                          setState(() {
                            titleValue = v;
                          });
                        }),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: customTextField(
                            10, maxContentLength, contentValue, "내용을 입력하세요",
                            (v) {
                          setState(() {
                            contentValue = v;
                          });
                        }),
                      ),
                      // 4. 텍스트 버튼
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            customTextButton('취소', kGrey, () {
                              Navigator.pop(context);
                            }),
                            customTextButton(
                              '저장',
                              kBlack,
                              () async {
                                if (isTodayDone && dateTime == kToday) {
                                  Fluttertoast.showToast(
                                      msg: "이미 작성 완료한 날짜입니다.");
                                } else if (_pickedImages.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "이미지는 1장 이상 등록해야합니다.");
                                } else if (titleValue.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "제목은 반드시 입력해야합니다.");
                                } else if (contentValue.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "내용은 반드시 입력해야합니다.");
                                } else {
                                  context.read<DBConnection>().createPost(
                                        _pickedImages,
                                        titleValue,
                                        contentValue,
                                        dateTime,
                                        uid,
                                      );
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(msg: "저장을 완료했습니다.");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: w,
              // height: h + 40,
              alignment: Alignment.bottomCenter,
              child: const Image(
                image: AssetImage('./assets/images/footer.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

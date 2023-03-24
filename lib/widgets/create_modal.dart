import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pidi/models/posts.dart';
import 'package:pidi/widgets/toast_message.dart';
import 'dart:io';

import '../constants.dart';
import '../models/singleton.dart';

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
  bool isTodayDone = false;
  DateTime recentDate = kToday;

  DateTime _selectedValue = kToday;
  DateTime dateTime = kToday;
  final DatePickerController _controller = DatePickerController();

  final ImagePicker picker = ImagePicker();
  List<XFile?> _pickedImages = [];

  Future getImage(ImageSource imageSource) async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        if (images.length > 5) {
          _pickedImages = images.sublist(0, 5);
          toastMessage(context, '최대 5장까지 등록 가능합니다.');
        } else {
          _pickedImages = images;
        }
      });
    }
  }

  Widget uploadImage(onPressed) {
    return SizedBox(
      width: 70,
      height: 70,
      child: OutlinedButton(
        onPressed: onPressed,
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

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    double w = mediaQueryData.size.width * 0.8;
    // double h = mediaQueryData.size.height * 0.55;
    // double mainWidth = datePickerSetting[0] == true ? w : w - 5;
    // double mainHeight = datePickerSetting[0] == true ? h : h - 30;
    final keyboardHeight = mediaQueryData.viewInsets.bottom;

    List<DateTime> deactivateDates = [];

    var postList = Singleton().postList;
    for (var v in postList) {
      deactivateDates.add(v.date);
      if (kToday.difference(v.date).inDays == 0) {
        setState(() {
          isTodayDone = true;
        });
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_selectedValue != DateTime.now()) {
        _controller.animateToDate(
            _selectedValue.subtract(const Duration(days: 3)),
            duration: const Duration(milliseconds: 100));
      }
    });

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
                // height: h,
                // margin: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. 데이트 피커
                        // datePickerSetting[1] == true ?
                        // 1-1. 캘린더 팝업형
                        TextButton(
                          onPressed: (() async {
                            DateTime? newDateTime = await showRoundedDatePicker(
                                context: context,
                                height: mediaQueryData.size.height * 0.43,
                                initialDate: kToday,
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
                                  textStyleDayButton: TextStyle(
                                      fontSize: kTitle, color: kBlack),
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
                                  // paddingActionBar: const EdgeInsets.all(0),
                                  // paddingDateYearHeader: const EdgeInsets.all(12),
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
                              });
                            }
                          }),
                          style: TextButton.styleFrom(primary: kGrey),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  DateFormat('yyyy-MM-dd EE', 'ko-KR')
                                      .format(dateTime),
                                  style: TextStyle(
                                      color: kBlack.withOpacity(0.8),
                                      fontSize: kContentS + 1)),
                              const SizedBox(width: 3),
                              Icon(Icons.edit_rounded,
                                  size: 15, color: kBlack.withOpacity(0.6))
                            ],
                          ),
                        ),
                        // 1-2. 슬라이더형
                        // : Container(
                        //     height: 70,
                        //     padding: const EdgeInsets.symmetric(vertical: 5),
                        //     child: DatePicker(
                        //       DateTime.now()
                        //           .subtract(const Duration(days: 31)),
                        //       width: 36,
                        //       controller: _controller,
                        //       initialSelectedDate:
                        //           isTodayDone ? null : kToday,
                        //       selectionColor: kBlack,
                        //       selectedTextColor: Colors.white,
                        //       monthTextStyle:
                        //           TextStyle(fontSize: 12, color: kGrey),
                        //       dateTextStyle: TextStyle(
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           color: kGrey),
                        //       dayTextStyle: const TextStyle(
                        //           fontSize: 0, color: Colors.transparent),
                        //       daysCount: 32,
                        //       inactiveDates: deactivateDates,
                        //       deactivatedColor: kUnderline,
                        //       onDateChange: (date) {
                        //         setState(() {
                        //           _selectedValue = date;
                        //         });
                        //       },
                        //       locale: 'ko-KR',
                        //     ),
                        //   ),
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
                                customTextButton('저장', kBlack, () async {
                                  if (isTodayDone && _selectedValue == kToday) {
                                    toastMessage(context, '날짜는 반드시 선택해야합니다.');
                                  } else if (_pickedImages.isEmpty) {
                                    toastMessage(
                                        context, '이미지는 1장 이상 등록해야합니다.');
                                  } else if (titleValue.isEmpty) {
                                    toastMessage(context, '제목은 반드시 입력해야합니다.');
                                  } else if (contentValue.isEmpty) {
                                    toastMessage(context, '내용은 반드시 입력해야합니다.');
                                  } else {
                                    Singleton().createPost(
                                      _pickedImages,
                                      titleValue,
                                      contentValue,
                                      _selectedValue,
                                      userid,
                                    );
                                    Navigator.pop(context);
                                    toastMessage(context, '저장을 완료했습니다.');
                                  }
                                })
                              ],
                            )),
                      ],
                    ),
                  ),
                )),
            Container(
                width: w,
                // height: h + 40,
                alignment: Alignment.bottomCenter,
                child: const Image(
                    image: AssetImage('./assets/images/footer.png'))),
          ],
        ),
      ),
    );
  }
}

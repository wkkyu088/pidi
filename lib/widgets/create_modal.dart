import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  DateTime _selectedValue = DateTime.now();
  DateTime dateTime = DateTime.now();
  final DatePickerController _controller = DatePickerController();

  final ImagePicker picker = ImagePicker();
  List<XFile?> _pickedImages = [];

  Future getImage(ImageSource imageSource) async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        if (images.length > 5) {
          _pickedImages = images.sublist(0, 5);
          showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pop(context);
                });

                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadiusL),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  insetPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.8),
                  elevation: 0,
                  backgroundColor: kWhite,
                  content: Builder(
                    builder: (context) {
                      return Container(
                          width: 100,
                          height: 20,
                          alignment: Alignment.center,
                          child: Text(
                            '최대 5장까지 등록 가능합니다.',
                            style:
                                TextStyle(color: kBlack, fontSize: kContentM),
                          ));
                    },
                  ),
                );
              });
        } else {
          _pickedImages = images;
        }
      });
    }
  }

  Widget uploadImage(onPressed) {
    return SizedBox(
      width: 75,
      height: 75,
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
    double mainWidth = datePickerSetting[0] == true ? w : w - 5;
    double h = mediaQueryData.size.height * 0.6;
    double mainHeight = datePickerSetting[0] == true ? h : h - 30;
    final keyboardHeight = mediaQueryData.viewInsets.bottom;

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
      return Stack(children: [
        TextField(
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: kContentM, color: kGrey),
              counterText: "",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: kBorderRadiusS,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrey),
                borderRadius: kBorderRadiusS,
              ),
              suffix: Text('${value.length}/$maxLength자',
                  style: TextStyle(fontSize: kSubText)),
            )),
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_selectedValue != DateTime.now()) {
        _controller.animateToDate(
            _selectedValue.subtract(const Duration(days: 3)),
            duration: const Duration(milliseconds: 100));
      }
    });

    return Container(
      margin: EdgeInsets.only(
          bottom: keyboardHeight > 0
              ? mediaQueryData.size.height * 0.15 + keyboardHeight * 0.4
              : mediaQueryData.size.height * 0.15),
      child: Stack(
        children: [
          SizedBox(
              width: mainWidth,
              child:
                  const Image(image: AssetImage('./assets/images/topper.png'))),
          Container(
              width: mainWidth,
              height: mainHeight + 40,
              alignment: Alignment.bottomCenter,
              child:
                  const Image(image: AssetImage('./assets/images/footer.png'))),
          // 0. 배경 컨테이너
          Container(
              width: mainWidth,
              height: mainHeight,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. 데이트 피커
                      datePickerSetting[1] == true
                          // 1-1. 캘린더 팝업형
                          ? Container(
                              child: TextButton(
                              onPressed: (() async {
                                DateTime? newDateTime =
                                    await showRoundedDatePicker(
                                        context: context,
                                        height:
                                            mediaQueryData.size.height * 0.45,
                                        initialDate: kToday,
                                        firstDate: kFirstDay,
                                        lastDate: kToday,
                                        borderRadius: 10,
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
                                            fontFamily: 'GowunDodum'),
                                        styleDatePicker:
                                            MaterialRoundedDatePickerStyle(
                                          textStyleDayButton: TextStyle(
                                              fontSize: 16, color: kBlack),
                                          textStyleYearButton: TextStyle(
                                              fontSize: 13, color: kBlack),
                                          textStyleDayHeader: TextStyle(
                                              fontSize: 14, color: kBlack),
                                          textStyleCurrentDayOnCalendar:
                                              TextStyle(
                                                  fontSize: 14,
                                                  color: kPoint,
                                                  fontWeight: FontWeight.bold),
                                          textStyleDayOnCalendar: TextStyle(
                                              fontSize: 14, color: kBlack),
                                          textStyleDayOnCalendarSelected:
                                              const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                          textStyleDayOnCalendarDisabled:
                                              TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      kBlack.withOpacity(0.1)),
                                          textStyleMonthYearHeader: TextStyle(
                                              fontSize: 16,
                                              color: kBlack,
                                              fontWeight: FontWeight.bold),
                                          paddingDatePicker:
                                              const EdgeInsets.all(10),
                                          paddingMonthHeader:
                                              const EdgeInsets.all(10),
                                          paddingActionBar:
                                              const EdgeInsets.all(0),
                                          paddingDateYearHeader:
                                              const EdgeInsets.all(15),
                                          sizeArrow: 24,
                                          colorArrowNext: kBlack,
                                          colorArrowPrevious: kBlack,
                                          marginLeftArrowPrevious: 8,
                                          marginTopArrowPrevious: 8,
                                          marginTopArrowNext: 8,
                                          marginRightArrowNext: 16,
                                          textStyleButtonAction: TextStyle(
                                              fontSize: 14, color: kBlack),
                                          textStyleButtonPositive: TextStyle(
                                              fontSize: 14,
                                              color: kBlack,
                                              fontWeight: FontWeight.bold),
                                          textStyleButtonNegative: TextStyle(
                                              fontSize: 16,
                                              color: kBlack.withOpacity(0.5)),
                                          decorationDateSelected: BoxDecoration(
                                              color: kBlack,
                                              shape: BoxShape.circle),
                                          backgroundPicker: Colors.white,
                                          backgroundActionBar: Colors.white,
                                          backgroundHeaderMonth: Colors.white,
                                        ),
                                        styleYearPicker:
                                            MaterialRoundedYearPickerStyle(
                                          textStyleYear: TextStyle(
                                              fontSize: 14, color: kBlack),
                                          textStyleYearSelected: TextStyle(
                                              fontSize: 18,
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
                            ))
                          // 1-2. 슬라이더형
                          : Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DatePicker(
                                DateTime.now()
                                    .subtract(const Duration(days: 31)),
                                width: 36,
                                controller: _controller,
                                initialSelectedDate: DateTime.now(),
                                selectionColor: kBlack,
                                selectedTextColor: Colors.white,
                                monthTextStyle:
                                    TextStyle(fontSize: 12, color: kGrey),
                                dateTextStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kGrey),
                                dayTextStyle: const TextStyle(
                                    fontSize: 0, color: Colors.transparent),
                                daysCount: 32,
                                onDateChange: (date) {
                                  setState(() {
                                    _selectedValue = date;
                                  });
                                },
                                locale: 'ko-KR',
                              ),
                            ),
                      // 2. 이미지 리스트
                      Container(
                          height: 85,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildImages(() {
                            getImage(ImageSource.gallery);
                          })),
                      // 3. 텍스트 필드
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(bottom: 5),
                        child: customTextField(
                            1, maxTitleLength, titleValue, "제목을 입력하세요", (v) {
                          setState(() {
                            titleValue = v;
                          });
                        }),
                      ),
                      Container(
                        height: 170,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: customTextField(
                            7, maxContentLength, contentValue, "내용을 입력하세요",
                            (v) {
                          setState(() {
                            contentValue = v;
                          });
                        }),
                      ),
                      // 4. 텍스트 버튼
                      Container(
                          height: 50,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              customTextButton('취소', kGrey, () {
                                Navigator.pop(context);
                              }),
                              customTextButton('저장', kBlack, () {})
                            ],
                          )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

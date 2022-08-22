import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class CreateModal extends StatefulWidget {
  const CreateModal({Key? key}) : super(key: key);

  @override
  State<CreateModal> createState() => _CreateModalState();
}

class _CreateModalState extends State<CreateModal> {
  double mainWidth = 320.0;
  double mainHeight = datePickerSetting[0] == true ? 470 : 450;

  final int maxTitleLength = 20;
  final int maxContentLength = 200;
  String titleValue = "";
  String contentValue = "";

  DateTime _selectedValue = DateTime.now();
  DateTime dateTime = DateTime.now();
  final DatePickerController _controller = DatePickerController();

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
            height: maxLines == 1 ? 50 : 176,
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_selectedValue != DateTime.now()) {
        _controller.animateToDate(
            _selectedValue.subtract(const Duration(days: 3)),
            duration: const Duration(milliseconds: 100));
      }
    });

    return Center(
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: Stack(
          children: [
            SizedBox(
                width: mainWidth,
                child: const Image(
                    image: AssetImage('./assets/images/topper.png'))),
            Container(
                width: mainWidth,
                height: mainHeight + 40,
                alignment: Alignment.bottomCenter,
                child: const Image(
                    image: AssetImage('./assets/images/footer.png'))),
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
                      children: [
                        // 1. 데이트 피커
                        datePickerSetting[1] == true
                            // 1-1. 캘린더 팝업형
                            ? Container(
                                height: 45,
                                margin: const EdgeInsets.only(top: 5),
                                child: TextButton(
                                  onPressed: (() async {
                                    DateTime? newDateTime =
                                        await showRoundedDatePicker(
                                            context: context,
                                            height: 400,
                                            borderRadius: 10,
                                            theme: ThemeData(
                                                primaryColor: kBackground,
                                                fontFamily: 'GowunDodum'),
                                            styleDatePicker:
                                                MaterialRoundedDatePickerStyle(
                                              textStyleDayButton: TextStyle(
                                                  fontSize: 18, color: kBlack),
                                              textStyleYearButton: TextStyle(
                                                  fontSize: 15, color: kBlack),
                                              textStyleDayHeader: TextStyle(
                                                  fontSize: 16, color: kBlack),
                                              textStyleCurrentDayOnCalendar:
                                                  TextStyle(
                                                      fontSize: 16,
                                                      color: kPoint,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textStyleDayOnCalendar: TextStyle(
                                                  fontSize: 16, color: kBlack),
                                              textStyleDayOnCalendarSelected:
                                                  const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textStyleDayOnCalendarDisabled:
                                                  TextStyle(
                                                      fontSize: 18,
                                                      color: kBlack
                                                          .withOpacity(0.1)),
                                              textStyleMonthYearHeader:
                                                  TextStyle(
                                                      fontSize: 18,
                                                      color: kBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  fontSize: 16, color: kBlack),
                                              textStyleButtonPositive:
                                                  TextStyle(
                                                      fontSize: 16,
                                                      color: kBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textStyleButtonNegative:
                                                  TextStyle(
                                                      fontSize: 18,
                                                      color: kBlack
                                                          .withOpacity(0.5)),
                                              decorationDateSelected:
                                                  BoxDecoration(
                                                      color: kBlack,
                                                      shape: BoxShape.circle),
                                              backgroundPicker: Colors.white,
                                              backgroundActionBar: Colors.white,
                                              backgroundHeaderMonth:
                                                  Colors.white,
                                            ),
                                            styleYearPicker:
                                                MaterialRoundedYearPickerStyle(
                                              textStyleYear: TextStyle(
                                                  fontSize: 16, color: kBlack),
                                              textStyleYearSelected: TextStyle(
                                                  fontSize: 20,
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
                                          size: 15,
                                          color: kBlack.withOpacity(0.6))
                                    ],
                                  ),
                                ))
                            // 1-2. 슬라이더형
                            : Container(
                                height: 55,
                                margin:
                                    const EdgeInsets.only(top: 13, bottom: 4),
                                child: DatePicker(
                                  DateTime.now()
                                      .subtract(const Duration(days: 31)),
                                  width: 36,
                                  controller: _controller,
                                  initialSelectedDate: DateTime.now(),
                                  selectionColor: kBlack,
                                  selectedTextColor: Colors.white,
                                  monthTextStyle:
                                      TextStyle(fontSize: 11, color: kGrey),
                                  dateTextStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kGrey),
                                  dayTextStyle: const TextStyle(fontSize: 0),
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
                        SizedBox(height: 90, child: _buildImages()),
                        // 3. 텍스트 필드
                        SizedBox(
                            height: 256,
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
                        // 4. 텍스트 버튼
                        SizedBox(
                            height: 40,
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

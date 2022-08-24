import 'package:flutter/material.dart';

import '../constants.dart';

AlertDialog customDialog(context, title, content, btn2, btn2Action) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
    actionsAlignment: MainAxisAlignment.spaceEvenly,
    title: Center(
      child: Text(title,
          style: TextStyle(
              color: kBlack, fontWeight: FontWeight.bold, fontSize: kAppBar)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          content,
          style: TextStyle(color: kBlack, fontSize: kTitle),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    actions: [
      SizedBox(
        width: 110,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
              primary: kGrey,
              side: BorderSide(color: kGrey),
              shape: RoundedRectangleBorder(borderRadius: kBorderRadius)),
          child:
              Text('취소', style: TextStyle(color: kGrey, fontSize: kContentM)),
        ),
      ),
      SizedBox(
        width: 110,
        child: TextButton(
          onPressed: btn2Action,
          style: TextButton.styleFrom(
              primary: kGrey,
              backgroundColor: kBlack,
              shape: RoundedRectangleBorder(borderRadius: kBorderRadius)),
          child:
              Text(btn2, style: TextStyle(color: kWhite, fontSize: kContentM)),
        ),
      ),
    ],
  );
}

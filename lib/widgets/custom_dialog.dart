import 'package:flutter/material.dart';

import '../constants.dart';

void customDialog(context, title, content, onPressed, {isDelete = false}) {
  final screenWidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        contentPadding: const EdgeInsets.only(top: 20),
        backgroundColor: kWhite,
        content: SizedBox(
          width: screenWidth * 0.7,
          height: 180,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: kTitle,
                  color: isDelete ? Colors.red : kBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kContentM,
                      height: 1.5,
                      color: kBlack,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kGrey,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10)),
                        ),
                        child: Text(
                          "취소",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: kContentM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onPressed,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDelete ? Colors.red : kBlack,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          "확인",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: kContentM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

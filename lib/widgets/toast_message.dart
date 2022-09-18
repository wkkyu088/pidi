import 'package:flutter/material.dart';

import '../constants.dart';

toastMessage(context, msg) {
  showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        // Future.delayed(const Duration(seconds: 2), () {
        //   Navigator.pop(context);
        // });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: kBorderRadiusL),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          insetPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.8),
          elevation: 0,
          backgroundColor: kBlack.withOpacity(0.8),
          content: Builder(
            builder: (context) {
              return Container(
                  width: 100,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    msg,
                    style: TextStyle(color: kWhite, fontSize: kContentM),
                  ));
            },
          ),
        );
      });
}

import 'package:flutter/material.dart';

final Null Function(BuildContext) showSpinner = (BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.white30,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondAnimation) {
      return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
        ),
      );
    },
  );
};

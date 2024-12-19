import 'package:flutter/material.dart';

void openSnackbar(context, text, [int durationSeconds = 2]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: durationSeconds),
    ),
  );
}

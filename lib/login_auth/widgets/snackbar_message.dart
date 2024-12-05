import 'package:flutter/material.dart';

snackBarMessage(dynamic context, String message) {
  var snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

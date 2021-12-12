import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.black26,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red)),
    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.grey));
import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/views/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SQlite Notes App',
    home: HomeScreen(),
  ));
}

import 'dart:math';

import 'package:flutter/material.dart';

double degToRad(num deg) => deg * (pi / 180.0);

double normalize(value, min, max) => ((value - min) / (max - min));

const Color kScaffoldBackgroundColor = Color.fromARGB(255, 255, 249, 249);
const double kDiameter = 300;
const double kMinDegree = 15;
const double kMaxDegree = 30;

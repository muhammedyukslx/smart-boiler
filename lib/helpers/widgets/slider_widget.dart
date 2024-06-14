import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../consts.dart';
import 'custom_draw.dart';

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double progressVal = 0.5;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("istenilenSicaklik").onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          final double currentTemp =
              double.parse(snapshot.data!.snapshot.value.toString());
          return Container(
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                      startAngle: degToRad(0),
                      endAngle: degToRad(184),
                      colors: [Colors.red, Colors.grey.withAlpha(30)],
                      stops: [progressVal, progressVal],
                      transform: GradientRotation(
                        degToRad(178),
                      ),
                    ).createShader(rect);
                  },
                  child: Center(
                    child: CustomArc(),
                  ),
                ),
                Center(
                  child: Container(
                    width: kDiameter - 30,
                    height: kDiameter - 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 20,
                          style: BorderStyle.solid,
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 30,
                              spreadRadius: 10,
                              color: Colors.red.withAlpha(
                                  normalize(progressVal * 20000, 100, 255)
                                      .toInt()),
                              offset: Offset(1, 3))
                        ]),
                    child: SleekCircularSlider(
                      min: kMinDegree,
                      max: kMaxDegree,
                      initialValue: currentTemp,
                      appearance: CircularSliderAppearance(
                        startAngle: 180,
                        angleRange: 180,
                        size: kDiameter - 30,
                        customWidths: CustomSliderWidths(
                          trackWidth: 10,
                          shadowWidth: 0,
                          progressBarWidth: 01,
                          handlerSize: 15,
                        ),
                        customColors: CustomSliderColors(
                          hideShadow: true,
                          progressBarColor: Colors.transparent,
                          trackColor: Colors.transparent,
                          dotColor: Colors.blue,
                        ),
                      ),
                      onChange: (value) async {
                        setState(() async {
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref();
                          await ref
                              .update({"istenilenSicaklik": value.toInt()});
                          // ref = FirebaseDatabase.instance.ref("roomTempSetPoint");
                          //roomTempSetPointEvent = value;
                          progressVal =
                              normalize(value, kMinDegree, kMaxDegree);
                        });
                      },
                      innerWidget: (percentage) {
                        return Center(
                          child: Text(
                            currentTemp.toString() + '°c',
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

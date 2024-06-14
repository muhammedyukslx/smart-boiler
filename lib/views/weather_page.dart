import 'package:flutter/material.dart';

import '../helpers/consts.dart';
import '../helpers/functions/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<WeatherModel> _weathers = [];

  void _getWeatherData() async {
    _weathers = await WeatherService.getWeatherData();
    setState(() {});
  }

  @override
  void initState() {
    _getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Haftalık Hava Durumu"),
      ),
      body: Center(
        child: WeatherService.isloading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Text(WeatherService.city),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _weathers.length,
                      itemBuilder: (context, index) {
                        final WeatherModel weather = _weathers[index];
                        return Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Image.network(weather.ikon, width: 100),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 25),
                                child: Text(
                                  "${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece}°",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Min: ${weather.min} °"),
                                      Text("Max: ${weather.max} °"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Gece: ${weather.gece} °"),
                                      Text("Nem: ${weather.nem}"),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

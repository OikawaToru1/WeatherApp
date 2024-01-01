import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/appID.dart';
import 'package:weather_app/hourly_forecast.dart';
import './additional_info.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Pokhara';

    try {
      final result = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,np&APPID=$openWeatherAPIKey"),
      );

      final data = jsonDecode(result.body);

      if (data['cod'] != "200") {
        throw "Unexpecter error found";
      }

      return data;

      // setState(() {
      //   isLoading = false;
      //   temp = (data["list"][0]["main"]["temp"]);
      // }
      // );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data["list"][0];
          String currentTemperatureinCelcius =
              (currentWeatherData["main"]["temp"] - 273)
                  .toString()
                  .substring(0, 4);

          final currentSky = currentWeatherData["weather"][0]["main"];
          final humidity = currentWeatherData["main"]["humidity"];
          final pressure = currentWeatherData["main"]["pressure"];
          final wind = currentWeatherData["wind"]["speed"];

          return Padding(
            padding: const EdgeInsetsDirectional.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2,
                          sigmaY: 2,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemperatureinCelcius °C",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                currentSky == "Clear" || currentSky == "Sunny"
                                    ? Icons.sunny
                                    : Icons.cloud,
                                size: 55,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 100,
                //         child: HourlyForecast(
                //           icon: Icons.cloud,
                //           time: "3pm",
                //           temperature: "300°K",
                //         ),
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: HourlyForecast(
                //           icon: Icons.cloud,
                //           time: "3:30 pm",
                //           temperature: "310°K",
                //         ),
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: HourlyForecast(
                //           icon: Icons.cloud,
                //           time: "3:40 pm",
                //           temperature: "290°K",
                //         ),
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: HourlyForecast(
                //           icon: Icons.sunny,
                //           time: "4pm",
                //           temperature: "270°K",
                //         ),
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: Card(
                //           child: HourlyForecast(
                //             icon: Icons.sunny,
                //             time: "4:30 pm",
                //             temperature: "26°K",
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 100,
                //         child: HourlyForecast(
                //           icon: Icons.cloud,
                //           time: "5 pm",
                //           temperature: "200°K",
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data["list"][index + 1];
                      final date = DateTime.parse(hourlyForecast["dt_txt"]);
                      final hourlyTemp = (hourlyForecast["main"]["temp"] - 273)
                          .toString()
                          .substring(0, 4);

                      return HourlyForecast(
                        icon: hourlyForecast["weather"][0]["main"] == "Clear" ||
                                hourlyForecast["weather"][0]["main"] == "Sunny"
                            ? Icons.sunny
                            : Icons.cloud,
                        time: DateFormat.j().format(date),
                        temperature: "${hourlyTemp}°C",
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalinfoBox(
                        icon: Icons.water_drop_outlined,
                        label: "Humidity",
                        value: humidity.toString(),
                      ),
                      AdditionalinfoBox(
                        icon: Icons.air,
                        label: "Wind",
                        value: wind.toString(),
                      ),
                      AdditionalinfoBox(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: pressure.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

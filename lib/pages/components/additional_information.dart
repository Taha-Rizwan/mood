import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionalInfo extends StatelessWidget {
  final List moodColors;
  final dynamic currentWeather;
  const AdditionalInfo(
      {required this.currentWeather, required this.moodColors, super.key});

  @override
  Widget build(BuildContext context) {
    // Formatting the directions given by the weather Api
    getDir(String dir) {
      if (dir == 'S') {
        return 'South';
      } else if (dir == 'N') {
        return 'North';
      } else if (dir == 'E') {
        return 'East';
      } else if (dir == 'W') {
        return 'West';
      } else if (dir == 'SW' || dir == 'SSW' || dir == 'WSW') {
        return 'SouthWest';
      } else if (dir == 'NW' || dir == 'NNW' || dir == 'WNW') {
        return 'NorthWest';
      } else if (dir == 'NE' || dir == 'NNE' || dir == 'ENE') {
        return 'NorthEast';
      } else if (dir == 'SE' || dir == 'SSE' || dir == 'ESE') {
        return 'SouthEast';
      } else {
        return 'Unknown';
      }
    }

    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: moodColors[2].withOpacity(0.25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        '3 Day Forecast',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                      'https:${currentWeather['forecast']['forecastday'][0]['day']['condition']['icon']}',
                                      height: 40,
                                      width: 40),
                                  const Text(
                                    "Today ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    currentWeather['forecast']['forecastday'][0]
                                        ['day']['condition']['text'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Text(
                                "${currentWeather['forecast']['forecastday'][0]['day']['maxtemp_c'].round().toString()}° /${currentWeather['forecast']['forecastday'][0]['day']['mintemp_c'].round().toString()}°",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                      'https:${currentWeather['forecast']['forecastday'][1]['day']['condition']['icon']}',
                                      height: 40,
                                      width: 40),
                                  const Text(
                                    'Tomorrow ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    currentWeather['forecast']['forecastday'][1]
                                        ['day']['condition']['text'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Text(
                                "${currentWeather['forecast']['forecastday'][1]['day']['maxtemp_c'].round().toString()}° /${currentWeather['forecast']['forecastday'][1]['day']['mintemp_c'].round().toString()}°",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                      'https:${currentWeather['forecast']['forecastday'][2]['day']['condition']['icon']}',
                                      height: 40,
                                      width: 40),
                                  Text(
                                    "${DateFormat('EEEE').format(DateTime.parse(currentWeather['forecast']['forecastday'][2]['date'])).toString()} ",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    currentWeather['forecast']['forecastday'][2]
                                        ['day']['condition']['text'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Text(
                                "${currentWeather['forecast']['forecastday'][2]['day']['maxtemp_c'].round().toString()}° /${currentWeather['forecast']['forecastday'][2]['day']['mintemp_c'].round().toString()}°",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: moodColors[2].withOpacity(0.25),
                        ),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.145,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Wind",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Speed: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${currentWeather['current']['wind_kph'].toString()}km/h',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Direction: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      getDir(currentWeather['current']
                                              ['wind_dir'])
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: moodColors[2].withOpacity(0.25),
                        ),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.145,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Astro",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Sunrise: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      currentWeather['forecast']['forecastday']
                                              [0]['astro']['sunrise']
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Sunset: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      currentWeather['forecast']['forecastday']
                                              [0]['astro']['sunset']
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: moodColors[2].withOpacity(0.25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Humidity: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${currentWeather['current']['humidity'].toString()}%",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: moodColors[1],
                            height: 0.5,
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Real Feel: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${currentWeather['current']['feelslike_c'].round().toString()}°",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: moodColors[1],
                            height: 0.5,
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "UV: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                currentWeather['current']['uv']
                                    .round()
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: moodColors[1],
                            height: 0.5,
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Pressure: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${currentWeather['current']['pressure_mb'].round().toString()}mb',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: moodColors[1],
                            height: 0.5,
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Rain(%): ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${currentWeather['forecast']['forecastday'][0]['day']['daily_chance_of_rain'].toString()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: moodColors[1],
                            height: 0.5,
                            thickness: 1,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

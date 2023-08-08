import 'package:flutter/material.dart';

class WearSheet extends StatelessWidget {
  final List clothes;
  final dynamic currentWeather;
  final List suggestions;
  final List moodColors;
  const WearSheet(
      {required this.clothes,
      required this.suggestions,
      required this.moodColors,
      required this.currentWeather,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: moodColors[2],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Divider(
                      color: moodColors[1],
                      height: 1,
                      thickness: 3,
                      indent: MediaQuery.of(context).size.width * 0.46,
                      endIndent: MediaQuery.of(context).size.width * 0.46),
                ),
              ),
              const Text(
                "What to Wear",
                style: TextStyle(
                  color: Color(0xffb2b2d42),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          clothes[0],
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.height * 0.08,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(suggestions[0],
                              style: const TextStyle(
                                  color: Color(0xffb2b2d42),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5),
                              maxLines: 2),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          clothes[1],
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.height * 0.08,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              suggestions[1],
                              style: const TextStyle(
                                  color: Color(0xffb2b2d42),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          clothes[2],
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.height * 0.08,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(suggestions[2],
                                style: const TextStyle(
                                    color: Color(0xffb2b2d42),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5),
                                maxLines: 2),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          clothes[3],
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.height * 0.08,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(suggestions[3],
                                style: const TextStyle(
                                    color: Color(0xffb2b2d42),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5),
                                maxLines: 2),
                          ),
                        ),
                      ],
                    ),
                    (currentWeather['forecast']['forecastday'][0]['day']
                                ['daily_chance_of_rain'] >=
                            45)
                        ? Row(
                            children: [
                              Image.asset(
                                'images/umbrella.gif',
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width:
                                    MediaQuery.of(context).size.height * 0.08,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                      "Keep an umbrella with you just in case",
                                      style: const TextStyle(
                                          color: Color(0xffb2b2d42),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5),
                                      maxLines: 2),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (currentWeather['current']['feelslike_c'] < 15 &&
                            currentWeather['forecast']['forecastday'][0]['day']
                                    ['daily_chance_of_rain'] <
                                45)
                        ? Row(
                            children: [
                              Image.asset(
                                'images/scarf.gif',
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width:
                                    MediaQuery.of(context).size.height * 0.08,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text("Don't forget that scarf!",
                                      style: const TextStyle(
                                          color: Color(0xffb2b2d42),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5),
                                      maxLines: 2),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

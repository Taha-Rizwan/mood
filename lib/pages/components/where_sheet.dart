import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class WhereSheet extends StatelessWidget {
  final dynamic data;
  final List moodColors;
  const WhereSheet({required this.data, required this.moodColors, super.key});

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: moodColors[2],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
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
              "Where to Go",
              style: TextStyle(
                  color: Color(0xffb2b2d42),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: data.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final url = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=${data[index]['properties']['lat']},${data[index]['properties']['lon']}');
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              },
                              icon: Shimmer.fromColors(
                                baseColor: Colors.black,
                                highlightColor: Colors.white38,
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 24,
                                ),
                              )),
                          Text(
                            data[index]['properties']['name'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          Text(
                            capitalize(
                                data[index]['properties']['categories'][0]),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

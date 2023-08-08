import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SongsSheet extends StatelessWidget {
  final dynamic songs;
  final List moodColors;
  const SongsSheet({required this.songs, required this.moodColors, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.525,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: moodColors[2],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
            "What to Listen",
            style: TextStyle(
                color: Color(0xffb2b2d42),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5),
            textAlign: TextAlign.center,
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            songs[index]['image'],
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              songs[index]['name'],
                              style: const TextStyle(
                                  color: Color(0xffb2b2d42),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              songs[index]['artist'],
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            onPressed: () async {
                              final url = Uri.parse(songs[index]['link']);
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            },
                            color: Color(0xffb1DB954),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Spotify',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                      )
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

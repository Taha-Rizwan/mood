//Imports
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:http/http.dart' as http;
import 'package:mood/pages/components/additional_information.dart';
import 'package:mood/pages/components/where_sheet.dart';
import 'package:mood/pages/components/wearSheet.dart';
import 'package:mood/pages/components/songs_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
// Weather Api "https://www.weatherapi.com/"
//  Geolocation api to get places in the city "https://apidocs.geoapify.com/"

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    checkFirstRun();
  }

  //Declaring variables
  final _textController = TextEditingController();
  String userLocation = '';
  String errorMessage = '';
  String weatherMood = '';
  dynamic currentWeather = {};
  bool loading = true;
  List moodColors = [];
  String quote = '';
  List places = [];
  bool placesLoading = false;
  bool buttonIsActive = true;
  bool firstRun = false;
  List songs = [];
  List clothes = [];
  List suggestions = [];
//Getting weather for a specific City
  getWeather(String city) async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url =
        "https://api.weatherapi.com/v1/forecast.json?key=14cc4f2f8784466fbdb100536213010&q=${city}&days=6";
    await http.get(Uri.parse(url), headers: <String, String>{
      'Access-Control-Allow-Origin': '*'
    }).then((value) {
      var responseData = json.decode(value.body);

      if (responseData.containsKey('error')) {
        return setState(() {
          errorMessage = 'No location found!';
          loading = false;
        });
      } else {
        return setState(() {
          userLocation = responseData['location']['name'];
          currentWeather = responseData;
          prefs.setString('city', responseData['location']['name']);
          errorMessage = '';
          placesLoading = false;
          getMood();
        });
      }
    }).onError((e, s) {
      print(e);
      if (prefs.containsKey('city')) {
        prefs.remove('city');
      }
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text(
                  "Network Error!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ));
      return setState(() {
        loading = false;
        userLocation = '';
      });
    });
  }

//Get the Current Weather condition/mood
  getMood() async {
    int code = currentWeather['current']['condition']['code'];
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/codes.json");
    final jsonResult = jsonDecode(data);
    if (jsonResult['rainy'].contains(code)) {
      setState(() {
        weatherMood = 'rainy';
      });
    } else if (jsonResult['cloudy'].contains(code)) {
      setState(() {
        weatherMood = 'cloudy';
      });
    } else if (jsonResult['sunny'].contains(code)) {
      setState(() {
        weatherMood = 'sunny';
      });
    } else if (jsonResult['foggy'].contains(code)) {
      setState(() {
        weatherMood = 'foggy';
      });
    } else {
      setState(() {
        weatherMood = 'snowy';
      });
    }
    getColors();
    return getQuote();
  }

  //Getting colors depending on the weather condtion/mood
  getColors() async {
    if (weatherMood == 'rainy') {
      setState(() {
        moodColors = [
          Color(0xffb023e8a),
          Color(0xffb48cae4),
          Color(0xffbB6EAFA)
        ];
      });
    } else if (weatherMood == 'cloudy') {
      setState(() {
        moodColors = [
          Color(0xffb414340),
          Color(0xffb9d9f9c),
          Color(0xffbD8D9DA)
        ];
      });
    } else if (weatherMood == 'sunny') {
      setState(() {
        moodColors = [
          Color(0xffbFDA707),
          Color(0xffbe7db3c),
          Color(0xffbF8FDCF)
        ];
      });
    } else if (weatherMood == 'foggy') {
      setState(() {
        moodColors = [
          Color(0xffb73628a),
          Color(0xffbcbc5ea),
          Color(0xffbFDE5EC)
        ];
      });
    } else {
      setState(() {
        moodColors = [
          Color(0xffb282a36),
          Color(0xffb6d6e76),
          Color(0xffbE3CAA5)
        ];
      });
    }
    setState(() {
      loading = false;
    });
  }

  //Getting a random quote depending on the weather condtion
  getQuote() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/quotes.json");
    final jsonResult = jsonDecode(data);
    final random = new Random();
    var result =
        jsonResult[weatherMood][random.nextInt(jsonResult[weatherMood].length)];
    return setState(() {
      quote = result;
    });
  }

  //Getting places in the city /  near the city depending on the weather condition
  getPlaces() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: (SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: moodColors[2],
                ),
              )),
            ));
    String url =
        'https://api.geoapify.com/v1/geocode/search?text=${userLocation}&format=json&apiKey=d6b1af1031e1485aa5087578457bff62';
    await http.get(Uri.parse(url), headers: <String, String>{
      'Access-Control-Allow-Origin': '*'
    }).then((value) async {
      var responseData = json.decode(value.body);
      var placeID = responseData['results'][0]['place_id'];
      if (weatherMood == 'sunny') {
        String url2 =
            'https://api.geoapify.com/v2/places?categories=catering.cafe&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response2 = await http.get(Uri.parse(url2),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData2 = json.decode(response2.body);
        if (responseData2['features'].length > 1) {
          for (var i = 0; i < responseData2['features'].length; i++) {
            places.add(responseData2['features'][i]);
          }
        }
        String url3 =
            'https://api.geoapify.com/v2/places?categories=leisure&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response3 = await http.get(Uri.parse(url3),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData3 = json.decode(response3.body);
        if (responseData3['features'].length > 1) {
          for (var i = 0; i < responseData3['features'].length; i++) {
            places.add(responseData3['features'][i]);
          }
        }
        String url4 =
            'https://api.geoapify.com/v2/places?categories=sport.swimming_pool&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response4 = await http.get(Uri.parse(url4),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData4 = json.decode(response4.body);
        if (responseData4['features'].length > 1) {
          for (var i = 0; i < responseData4['features'].length; i++) {
            places.add(responseData4['features'][i]);
          }
        }
      } else if (weatherMood == 'cloudy' ||
          weatherMood == 'rainy' ||
          weatherMood == 'snowy' ||
          weatherMood == 'foggy') {
        String url2 =
            'https://api.geoapify.com/v2/places?categories=catering.restaurant&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response2 = await http.get(Uri.parse(url2),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData2 = json.decode(response2.body);
        if (responseData2['features'].length > 1) {
          for (var i = 0; i < responseData2['features'].length; i++) {
            places.add(responseData2['features'][i]);
          }
        }
        String url3 =
            'https://api.geoapify.com/v2/places?categories=entertainment.museum&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response3 = await http.get(Uri.parse(url3),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData3 = json.decode(response3.body);
        if (responseData3['features'].length > 1) {
          for (var i = 0; i < responseData3['features'].length; i++) {
            places.add(responseData3['features'][i]);
          }
        }
        String url4 =
            'https://api.geoapify.com/v2/places?categories=entertainment.cinema&filter=place:${placeID}&conditions=named&limit=15&apiKey=d6b1af1031e1485aa5087578457bff62';
        final response4 = await http.get(Uri.parse(url4),
            headers: <String, String>{'Access-Control-Allow-Origin': '*'});
        var responseData4 = json.decode(response4.body);
        if (responseData4['features'].length > 1) {
          for (var i = 0; i < responseData4['features'].length; i++) {
            places.add(responseData4['features'][i]);
          }
        }

        setState(() {
          places = places;
          buttonIsActive = true;
        });
      }
      Navigator.pop(context);
      onClickPlaces();
    }).catchError((e) {
      setState(() {
        places = [];
        buttonIsActive = true;
      });

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Network Error!"),
                backgroundColor: moodColors[0],
              ));
    });
  }

//Checking if its the first time an app is run and also checking if there is a user location saved to the local storage and calling getWeather()
  checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('city')) {
      var loc = prefs.getString('city');

      getWeather(loc.toString());
    }

    bool result = await IsFirstRun.isFirstRun();
    return Timer(const Duration(seconds: 1), () {
      if (result == true) {
        setState(() {
          firstRun = result;
          loading = false;
        });
      } else {
        setState(() {
          if (!prefs.containsKey('city')) {
            loading = false;
          }
          firstRun = result;
        });
      }
    });
  }

//Displaying places after places have been loaded in
  onClickPlaces() {
    var random = Random();
    // Create a new empty list
    var newList = [];
    // Create a new empty set
    var indices = Set();
    // Loop until the set has 12 elements
    while (indices.length < 12) {
      // Generate a random index
      var index = random.nextInt(places.length);
      // Check if the set contains the index
      if (!indices.contains(index)) {
        // Add it to the set
        indices.add(index);
        // Add the corresponding element to the new list
        newList.add(places[index]);
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => WhereSheet(
              data: newList,
              moodColors: moodColors,
            ));
    setState(() {
      buttonIsActive = true;
      placesLoading = true;
    });
  }

  //Getting songs depending on the weather mood / condition
  getSong() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/songs.json");
    final jsonResult = jsonDecode(data);

    var random = Random();
    // Create a new empty set
    var indices = Set();
    songs.clear();
    // Loop until the set has 5 elements
    while (indices.length < 6) {
      // Generate a random index
      var index = random.nextInt(jsonResult[weatherMood].length);
      // Check if the set contains the index
      if (!indices.contains(index)) {
        // Add it to the set
        indices.add(index);
        // Add the corresponding element to the new list
        songs.add(jsonResult[weatherMood][index]);
      }
    }
    setState(() {
      songs = songs;
    });
  }

//Suggesting clothes to wear depending on the weather mood/condition
  getClothes() async {
    suggestions.clear();
    clothes.clear();
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/clothes.json");
    final jsonResult = jsonDecode(data);
    final random = new Random();

    if (currentWeather["current"]["feelslike_c"] < 20) {
      clothes.add(jsonResult["<20"]['head']
          [random.nextInt(jsonResult["<20"]['head'].length)]);
      suggestions.add("Cold day, don't forget your beanie and scarf.");
      clothes.add(jsonResult["<20"]['body']
          [random.nextInt(jsonResult["<20"]['body'].length)]);
      suggestions
          .add("Wear atleast two layers, a shirt and a jacket will do nicely.");
      clothes.add(jsonResult["<20"]['legs']
          [random.nextInt(jsonResult["<20"]['legs'].length)]);
      suggestions.add("Jeans or a full trouser, don't freeze in place.");
      clothes.add(jsonResult["<20"]['shoes']
          [random.nextInt(jsonResult["<20"]['shoes'].length)]);
      suggestions.add("Closed shoes with socks or you'll have cold feet.");
    } else if (currentWeather["current"]["feelslike_c"] >= 20 &&
        currentWeather["current"]["feelslike_c"] <= 24) {
      clothes.add(jsonResult["20-27"]['head']
          [random.nextInt(jsonResult["20-27"]['head'].length)]);
      suggestions.add("Kinda  cold, maybe wear a beanie, maybe not.");
      clothes.add(jsonResult["20-27"]['body']
          [random.nextInt(jsonResult["20-27"]['body'].length)]);
      suggestions.add("Shiver me timbers, two layers atleast.");
      clothes.add(jsonResult["20-27"]['legs']
          [random.nextInt(jsonResult["20-27"]['legs'].length)]);

      suggestions.add("Jeans or a full trouser, don't freeze in place");
      clothes.add(jsonResult["20-27"]['shoes']
          [random.nextInt(jsonResult["20-27"]['shoes'].length)]);
      suggestions.add("Closed shoes with socks or you'll have cold feet.");
    } else if (currentWeather["current"]["feelslike_c"] >= 25 &&
        currentWeather["current"]["feelslike_c"] <= 35) {
      clothes.add(jsonResult["27-35"]['head']
          [random.nextInt(jsonResult["27-35"]['head'].length)]);
      suggestions.add("It's hot, nothing needed or maybe a cap.");
      clothes.add(jsonResult["27-35"]['body']
          [random.nextInt(jsonResult["27-35"]['body'].length)]);
      suggestions.add("Half Sleeves with the summer vibes.");
      clothes.add(jsonResult["27-35"]['legs']
          [random.nextInt(jsonResult["27-35"]['legs'].length)]);
      suggestions.add("Either shorts or jeans will do nicely.");
      clothes.add(jsonResult["27-35"]['shoes']
          [random.nextInt(jsonResult["27-35"]['shoes'].length)]);
      suggestions.add("Rock the sneakers or the sandals.");
    } else {
      clothes.add(jsonResult["35>"]['head']
          [random.nextInt(jsonResult["35>"]['head'].length)]);
      suggestions.add("It's hot, nothing needed or mayber a cap.");
      clothes.add(jsonResult["35>"]['body']
          [random.nextInt(jsonResult["35>"]['body'].length)]);
      suggestions.add("Time to bring out the tank tops and tees.");
      clothes.add(jsonResult["35>"]['legs']
          [random.nextInt(jsonResult["35>"]['legs'].length)]);
      suggestions.add("Get in the trunks and get in the pool.");
      clothes.add(jsonResult["35>"]['shoes']
          [random.nextInt(jsonResult["35>"]['shoes'].length)]);
      suggestions.add("Flip Flops or sandal, nothing else");
    }

    setState(() {
      clothes = clothes;
      suggestions = suggestions;
    });
  }

  onDonePress() {
    return setState(() {
      firstRun = false;
    });
  }

  //IntroSlider Stuff
  List<ContentConfig> listContentConfig = [
    const ContentConfig(
        title: "Mood",
        description: "The Only Weather App you'll need",
        backgroundImage: 'images/sunny.jpg'),
    const ContentConfig(
        title: "Where we going",
        description: "Always know what to wear and where to go",
        backgroundImage: 'images/snowy.jpg'),
    const ContentConfig(
        title: "What to Listen",
        description: "We suggest tunes too",
        backgroundImage: 'images/rainy.jpg'),
    const ContentConfig(
      title: "What to Wear",
      description: "What should we wear today",
      backgroundImage: 'images/cloudy.jpg',
    ),
    const ContentConfig(
        title: "Get Started",
        description: "Let's see what mood you should be in today.",
        backgroundImage: 'images/foggy.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    //Intro Slider for first run
    if (firstRun == true && loading == false) {
      return (IntroSlider(
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        onDonePress: onDonePress,
      ));
    }
    // Circular Progress Indicator
    else if (loading == true) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffb2b2d42),
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1),
                builder: (context, value, _) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: value as double,
                      backgroundColor: Colors.white54,
                      color: Colors.white,
                      strokeWidth: 10,
                    ),
                  );
                }),
          )));
    }
    // Starting Screen for user to input a location
    else if (userLocation == '' && loading == false) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffb2b2d42),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Color(0xffb2b2d42),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white54,
                        highlightColor: Colors.white,
                        child: const Icon(Icons.my_location_outlined,
                            color: Colors.white)),
                  ),
                ),
                const Text(
                  "mood.",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffb2b2d42)),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Choose your location!',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffb2b2d42)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Color(0xffb2b2d42)),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _textController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: 'Enter the name of your City!',
                        hintStyle: const TextStyle(color: Color(0xffb2b2d42)),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Color(0xffb2b2d42)),
                        )),
                  ),
                ),
                Text(
                  errorMessage,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      getWeather(_textController.text);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 24, color: Color(0xffb2b2d42)),
                    )),
              ],
            ),
          ),
        ),
      );
    }
    // Home Screen
    else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 0.0),
            colors: [moodColors[0], moodColors[1]],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: TextButton(
              onPressed: () {
                _textController.clear();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor: moodColors[0],
                          title: const Text(
                            'Current Location:',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    userLocation,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            _textController.clear();
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          )),
                                      hintText: 'Change your location!',
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide:
                                            BorderSide(color: moodColors[1]),
                                      )),
                                ),
                                Text(
                                  errorMessage,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          await getWeather(
                                              _textController.text);

                                          if (errorMessage ==
                                              'No location found!') {
                                            setState(() {
                                              errorMessage =
                                                  'No location found!';
                                            });
                                          } else {
                                            Navigator.of(context).pop();
                                            places.clear();
                                            setState(() {
                                              places = places;
                                            });
                                          }
                                        },
                                        child: const Text('Save')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel')),
                                  ],
                                ),
                              ],
                            )
                          ],
                        );
                      });
                    });
              },
              child: Text(
                userLocation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xffF6F1F1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 56.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "“${quote.toString()}”",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentWeather['current']['temp_c'].round().toString(),
                        style: const TextStyle(
                            fontSize: 100, fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          "°C",
                          style: TextStyle(fontSize: 60),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currentWeather['current']['condition']['text'].toString()} ${currentWeather['forecast']['forecastday'][0]['day']['maxtemp_c'].round().toString()}° / ${currentWeather['forecast']['forecastday'][0]['day']['mintemp_c'].round().toString()}°",
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Feels Like ${currentWeather['current']['feelslike_c'].round().toString()}°C",
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: moodColors[0],
                                  ),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Shimmer.fromColors(
                                  baseColor: moodColors[0],
                                  highlightColor: Colors.white,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.man_3_outlined,
                                        color: moodColors[0],
                                      ),
                                      onPressed: () async {
                                        await getClothes();
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) => WearSheet(
                                                clothes: clothes,
                                                suggestions: suggestions,
                                                moodColors: moodColors,
                                                currentWeather:
                                                    currentWeather));
                                      })))),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: moodColors[0],
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Shimmer.fromColors(
                              baseColor: moodColors[0],
                              highlightColor: Colors.white,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.holiday_village_outlined,
                                    color: moodColors[0],
                                  ),
                                  onPressed: buttonIsActive
                                      ? () {
                                          if (placesLoading == false) {
                                            setState(() {
                                              buttonIsActive = false;
                                            });

                                            getPlaces();
                                          } else {
                                            onClickPlaces();
                                          }
                                        }
                                      : () {}),
                            )),
                      )
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: moodColors[0],
                          ),
                          borderRadius: BorderRadius.circular(25)),
                      child: Shimmer.fromColors(
                        baseColor: moodColors[0],
                        highlightColor: Colors.white,
                        child: IconButton(
                            icon: Icon(
                              Icons.my_library_music_outlined,
                              color: moodColors[0],
                            ),
                            onPressed: () async {
                              await getSong();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SongsSheet(
                                      moodColors: moodColors, songs: songs));
                            }),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  AdditionalInfo(
                      currentWeather: currentWeather, moodColors: moodColors),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

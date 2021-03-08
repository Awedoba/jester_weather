import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      home: MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var day;
  var date;
  var sunrise;
  var sunset;
  var humidity;
  var temperature;
  var description;
  var currently;
  var city;

  Future getWeather() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?lat=' +
            _locationData.latitude.toString() +
            '&lon=' +
            _locationData.longitude.toString() +
            '&units=imperial&appid=08f57cec09b55a73f5eecd4f73d87bac');
    var result = jsonDecode(response.body);
    setState(() {
      this.day = result;
      this.date = new DateFormat('HH:mm a')
          .format(DateTime.fromMicrosecondsSinceEpoch(result['dt']));
      this.sunrise = new DateFormat('HH:mm a').format(
          DateTime.fromMicrosecondsSinceEpoch(result['sys']['sunrise']));
      this.sunset = new DateFormat('HH:mm a')
          .format(DateTime.fromMicrosecondsSinceEpoch(result['sys']['sunset']));
      this.humidity = result['main']['humidity'];
      this.temperature = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.currently = result['weather'][0]['main'];
      this.city = result['name'];
    });
    print(this.currently);
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
            ),
            Positioned(
              top: height * (0.64),
              child: Container(
                height: height * (0.3),
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: <Widget>[
//                      sunrise
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.solidSun,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Sunrise',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '$sunrise ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),

//                      sunset
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.solidSun,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Sunset',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '$sunset ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
//                      humidity
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.tint,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Humidity',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '$humidity %',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
//                      temperature
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.thermometerHalf,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Temperature',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "$temperature°C",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -(height / 4),
              bottom: height * (1 / 3),
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        '$currently',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ),
//                    FlatButton(
//                      child: Text('onclick'),
//                      onPressed: () {
//                        getLocation();
//                      },
//                    ),
                    //weather description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: FaIcon(
                        FontAwesomeIcons.cloudSun,
                        size: 150,
                      ),
                    ),
                    //time
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        '$city',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
//day
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45.0),
                      child: Text(
                        '$city',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

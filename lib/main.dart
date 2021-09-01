import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//"https://getintopik.com/wp-content/uploads/2019/10/Golden-Gate-Bridge-Minimal-Art-iPhone-Wallpaper-Free.jpg"
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  var aqi, ci, co, no2, o3, descP;

  var temp, city, hum, clouds, wind, desc;

  var _url;

  @override
  void initState() {
    super.initState();
    _funzione();
  }

  void _funzione() async {
    TimeOfDay nowTime = TimeOfDay.now();
    double _doubleNowTime =
        nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);

    setState(() {
      if (_doubleNowTime.round() >= 18 && _doubleNowTime.round() <= 07) {
        this._url =
            "https://i.pinimg.com/originals/fe/33/8a/fe338a1b86bee326babf93285b1e6877.jpg";
      } else if (_doubleNowTime.round() > 7 && _doubleNowTime.round() <= 12) {
        this._url =
            "https://i.pinimg.com/736x/bd/f5/21/bdf52158875071dd250c60ae03b9fd61.jpg";
      } else if (_doubleNowTime.round() > 12 && _doubleNowTime.round() <= 17) {
        this._url =
            "https://i.pinimg.com/736x/bd/f5/21/bdf52158875071dd250c60ae03b9fd61.jpg";
      } else {
        this._url =
            "https://getintopik.com/wp-content/uploads/2019/10/Golden-Gate-Bridge-Minimal-Art-iPhone-Wallpaper-Free.jpg";
      }

      this.city = "Loading";
      this.temp = "Loading";
      this.hum = "Loading";
      this.clouds = "Loading";
      this.wind = "Loading";
      this.desc = "Loading";

      this.aqi = "Loading";
      this.co = "Loading";
      this.o3 = "Loading";
      this.no2 = "Loading";
      this.descP = "Loading";
    });

    Location location = new Location();
    final locationData = await location.getLocation();
    var lat = locationData.latitude;
    var long = locationData.longitude;

    http.Response responsePollution = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/air_pollution?lat=" +
            "$lat" +
            "&lon=" +
            "$long" +
            "&appid=f84e05d1a0624de2781d654cfa73d342"));

    http.Response responseWeather = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?lat=" +
            "$lat" +
            "&lon=" +
            "$long" +
            "&appid=f84e05d1a0624de2781d654cfa73d342"));

    var resultPollution = await jsonDecode(responsePollution.body);
    var resultWeather = await jsonDecode(responseWeather.body);

    setState(() {
      this.city = resultWeather["name"];
      this.temp = ((resultWeather["main"]["temp"]) - 273.15).round();
      this.hum = resultWeather["main"]["humidity"];
      this.clouds = resultWeather["clouds"]["all"];
      this.wind = resultWeather["wind"]["speed"];
      this.desc = (resultWeather["weather"][0])["main"];

      this.aqi = (resultPollution["list"][0])["main"]["aqi"];
      this.co = ((resultPollution["list"][0])["components"]["co"]).round();
      this.o3 = (resultPollution["list"][0])["components"]["o3"];
      this.no2 = (resultPollution["list"][0])["components"]["no2"];
      if (this.aqi >= 0 && this.aqi <= 50) {
        this.descP = "Good";
      } else if (this.aqi >= 51 && this.aqi <= 100) {
        this.descP = "Moderate";
      } else if (this.aqi >= 101 && this.aqi <= 150) {
        this.descP = "Unhealthy for Sensitive Seople";
      } else if (this.aqi >= 151 && this.aqi <= 200) {
        this.descP = "Unhealthy";
      } else if (this.aqi >= 201 && this.aqi <= 300) {
        this.descP = "Very Unhealthy";
      } else if (this.aqi >= 301 && this.aqi <= 500) {
        this.descP = "Invivible";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        (Expanded(
            flex: 6,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 100.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0), //(x,y)
                            blurRadius: 6.0,
                          )
                        ],
                        image: DecorationImage(
                            image: NetworkImage(_url), fit: BoxFit.cover)),
                    child: Column(
                      children: [
                        (Text(
                          _index == 0 ? desc.toString() : descP.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        (Placeholder(
                            fallbackHeight: 25, color: Colors.transparent)),
                        (Text(
                          _index == 0 ? temp.toString() + "°" : aqi.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )),
                        (Placeholder(
                          fallbackHeight: 100,
                          color: Colors.transparent,
                        )),
                        (Align(
                            alignment: Alignment.bottomRight,
                            child: RawMaterialButton(
                              onPressed: () {
                                _funzione();
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: FaIcon(
                                FontAwesomeIcons.spinner,
                                size: 35.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ))),
                      ],
                    ))))),
        (Expanded(
            flex: 4,
            child: Scaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _index,
                  onTap: (int index) => setState(() => _index = index),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.temperatureHigh),
                      label: 'Weather',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.skull),
                      label: 'Pollution',
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    (Padding(
                        padding: EdgeInsets.only(top: 16.6),
                        child: Align(
                            child: Text(
                          city.toString(),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )))),
                    (Expanded(
                        child: SizedBox(
                            child: ListView(
                      children: [
                        (ListTile(
                          leading: Icon(Icons.thermostat),
                          title: Text(
                            (_index == 0 ? "Temperature" : "Aqi indicator"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          trailing: Text(
                              (_index == 0
                                  ? temp.toString() + "°"
                                  : aqi.toString()),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                        (ListTile(
                          leading: Icon(Icons.cloud_circle),
                          title: Text(
                            (_index == 0 ? "Clouds" : "Carbon monoxide"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          trailing: Text(
                              _index == 0 ? clouds.toString() : co.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                        (ListTile(
                          leading: FaIcon(FontAwesomeIcons.water),
                          title: Text(
                            (_index == 0 ? "Humidity" : "Nitrogen Dioxide"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          trailing: Text(
                              _index == 0 ? hum.toString() : no2.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                        (ListTile(
                          leading: FaIcon(FontAwesomeIcons.wind),
                          title: Text(
                            (_index == 0 ? "Wind" : "Ozone"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          trailing: Text(
                              _index == 0 ? wind.toString() : o3.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                      ],
                    ))))
                  ],
                )))),
      ],
    ));
  }
}

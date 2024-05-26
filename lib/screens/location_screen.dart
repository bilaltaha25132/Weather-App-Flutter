import 'package:flutter/material.dart';
import '/utilities/constants.dart';
import 'package:weather_app_flutter/screens/city_screen.dart';
import 'package:weather_app_flutter/services/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({@required this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temp = 0;
  int condition = 0;
  String city = 'Unknown';
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        condition = 0;
        city = 'Unable to get weather data';
        return;
      }
      double temperature = weatherData['main']['temp'];
      temp = temperature.toInt();
      condition = weatherData['weather'][0]['id'];
      city = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.near_me),
            onPressed: () async {
              var weatherData = await weatherModel.getLocationWeather();
              updateUI(weatherData);
            },
            iconSize: 30.0,
          ),
          IconButton(
            icon: Icon(Icons.location_city),
            onPressed: () async {
              var typedCityName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityScreen(),
                ),
              );
              if (typedCityName != null) {
                var weatherData =
                    await weatherModel.getCityWeather(typedCityName);
                updateUI(weatherData);
              }
            },
            iconSize: 30.0,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$city',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherModel.getWeatherIcon(condition),
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, bottom: 20.0),
                child: Text(
                  weatherModel.getMessage(temp),
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

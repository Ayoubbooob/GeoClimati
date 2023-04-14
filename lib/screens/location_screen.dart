import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.weatherData});

  final dynamic weatherData;
  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  int? temp;
  String? city;
  String? weatherIcon;
  String? weatherMsg;
  WeatherModel? weather;
  int backgroundPicNumero = 0;

  updateUi(dynamic locationWeather) {
    setState(() {
      if (locationWeather == null) {
        temp = 0;
        weatherIcon = 'Error';
        weatherMsg = 'Unable to get weather data';
        city = '';
        return;
      }
      final tempData = locationWeather['main']['temp'];
      temp = tempData.toInt();
      city = 'in ${locationWeather['name']}';
      final conditionData = locationWeather['weather'][0]['id'];
      int condition = conditionData.toInt();
      backgroundPicNumero = getBackgroundPicNumero(condition);
      weather = WeatherModel();
      weatherIcon = weather!.getWeatherIcon(condition);
      weatherMsg = weather!.getMessage(temp!);
    });
  }

  int getBackgroundPicNumero(int condition) {
    if (condition < 600) {
      return 2; //RAINNING
    } else if (condition < 700) {
      return 3; //Snowing
    } else if (condition == 800) {
      return 4; //sunny
    } else if (condition <= 804) {
      return 1; //cloudy
    } else {
      return 0; //unkown
    }
  }

  @override
  void initState() {
    super.initState();
    updateUi(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background$backgroundPicNumero.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var wheatherData = await weather!.getLocationData();
                      updateUi(wheatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return const CityScreen();
                          }),
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather!.getDataByCityName(typedName);
                        updateUi(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMsg $city',
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

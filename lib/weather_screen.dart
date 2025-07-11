import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_3/additional_information.dart';
import 'package:flutter_application_3/hourly_forecast_card.dart';

class WeatherScreen extends StatefulWidget {
   const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
 //double temp = 0;
 //@override
  //void initState() {
    //super.initState();
    //getCurrentWeather();
  //}
  
Future getCurrentWeather() async{
  // try{
String cityName = 'Nigeria';

final res = await http.get(
  Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=589fd05beea57b17764fc51c5c38f67b'),
    );
    final data = jsonDecode(res.body);
    if (data['cod'] != '200') {
      throw 'An unexpected error occured';
    } 
    return data;
    //setState(() {
      //temp = data['list'][0]['main']['temp'];
    //});
    
   //} catch (e) {
    //throw e.toString();
  // }
  }

 

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 230, 238),
      appBar: AppBar(
        title: Text('Weather App', style:TextStyle(
          fontWeight: FontWeight.bold
        )), 
        centerTitle: true,
        actions: [
      IconButton(onPressed: () {
        setState(() {
          getCurrentWeather();
        });
      }, icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather() ,
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentWeather = currentWeatherData ['weather'][0]['main'] ;
          final currentHumidity = currentWeatherData ['main']['humidity'];
          final currentPressure = currentWeatherData ['main']['pressure'];
          final currentWindSpeed = currentWeatherData ['wind']['speed'];


          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          children: [
          SizedBox(width:double.infinity, child: 
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 10,
            child: ClipRRect(borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                          Text('$currentTemp K', style: TextStyle(fontSize: 32, fontWeight:FontWeight.bold),),
                          SizedBox(height: 16,),
                          Icon(currentWeather == 'Clouds' || currentWeather == 'Rain' ? Icons.cloud : Icons.sunny, size: 42,),
                          SizedBox(height: 16,),
                          Text(currentWeather, style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
          SizedBox(height: 20,),
          Align(alignment: Alignment.topLeft,
            child: Text("Hourly Forecast", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
            SizedBox(height: 10),
            // SingleChildScrollView(scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [ 
            //       for(int i = 1; i < 20; i++)
            //       HourlyForecastCard(
            //         time: data['list'][i]['dt'].toString(),
            //         icon: data['list'][i]['weather'][0]['main'] == 'Clouds' || data['list'][i]['weather'][0]['main']== 'Rain' ? Icons.cloud : Icons.sunny,
            //         value: data['list'][i]['main']['temp'].toString()
            //       ),
                  
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return  HourlyForecastCard(
                      time: (data['list'][index]['dt_txt'].toString()).substring(11,16),
                      icon: data['list'][index ]['weather'][0]['main'] == 'Clouds' || data['list'][index]['weather'][0]['main']== 'Rain' ? Icons.cloud : Icons.sunny,
                      value: '${data['list'][index + 1]['main']['temp']} K'
                    );
              
                }
                ),
            ),
          SizedBox(height: 20,),
          Align(alignment: Alignment.topLeft,
            child: Text("Additional Information", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AdditionalInformation(
                icon: Icons.water_drop,
                label: "Humidity",
                value: currentHumidity.toString(),
              ),
               AdditionalInformation(
                icon: Icons.air,
                label: "Wind Speed",
                value: currentWindSpeed.toString(),
               ),
                AdditionalInformation(
                  icon: Icons.fire_hydrant_alt_outlined,
                label: "Pressure",
                value: currentPressure.toString(),
                ),
        
              // Column(
              //   children: [
              //     Icon(Icons.water_drop, size: 40,),
              //     SizedBox(height: 8,),
              //     Text('Humidity', style: TextStyle(fontSize: 15),),
              //     SizedBox(height: 8,),
              //     Text('94', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
              //   ],
              // ),
              // Column(
              //   children: [
              //     Icon(Icons.air, size: 40,),
              //     SizedBox(height: 8,),
              //     Text('Wind Speed', style: TextStyle(fontSize: 15),),
              //     SizedBox(height: 8,),
              //     Text('7.67', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
              //   ],
              // ),
              // Column(
              //   children: [
              //     Icon(Icons.fire_hydrant_alt_outlined, size: 40,),
              //     SizedBox(height: 8,),
              //     Text('Pressure', style: TextStyle(fontSize: 15),),
              //     SizedBox(height: 8,),
              //     Text('1006', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
              //   ],
              // )
            ],
          )
          
          ],
          ),
        );
        },
      )
    );
  }
}

// class HourlyForecastCard extends StatelessWidget {
//   const HourlyForecastCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(width: 100,
//                   child: Card( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     elevation: 6,
//                     child: 
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(children: [
//                         Text('09:00', style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold),),
//                               SizedBox(height: 10,),
//                               Icon(Icons.cloud, size: 40,),
//                               SizedBox(height: 10,),
//                               Text('301.17', style: TextStyle(fontSize: 15),)
//                       ],),
//                     )
//                   ),
//                 );
//   }
// }
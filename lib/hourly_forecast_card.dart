import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const HourlyForecastCard({super.key, required this.time,
  required this.icon,
  required this.value}
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100,
                  child: Card( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Text(
                          maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                          time, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold),),
                              SizedBox(height: 10,),
                              Icon(icon, size: 40,),
                              SizedBox(height: 10,),
                              Text(value, style: TextStyle(fontSize: 15),)
                      ],),
                    )
                  ),
                ); 
  }
}
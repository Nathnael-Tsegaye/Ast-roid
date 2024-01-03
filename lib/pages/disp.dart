// disp.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Disp extends StatefulWidget {
  final String start_date;
  final String end_date;

  Disp({required this.start_date, required this.end_date});

  @override
  _DispState createState() => _DispState();
}

class _DispState extends State<Disp> {
  List<String> neoInfo = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.start_date, widget.end_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('NEO Information:'),
            Expanded(
              child: neoInfo.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(), //  loading indicator
                    )
                  : ListView.builder(
                      itemCount: neoInfo.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(neoInfo[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData(String start_date, String end_date) async {
    final String apiUrl = 'https://api.nasa.gov/neo/rest/v1/feed';
    final String apiKey = 'ndc70eTHdnNguJPUdd1bLpFDSedrpWHSnOwtLsbP';

    final String url = '$apiUrl?start_date=$start_date&end_date=$end_date&detailed=false&api_key=$apiKey';

    final Map<String, String> requestBody = {
      'start_date': start_date,
      'end_date': end_date,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        setState(() {
          neoInfo = extractNeoInfo(json.decode(response.body));
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          neoInfo = ['Error: ${response.statusCode}'];
        });
      }
    } catch (e) {
      print('Error during API call: $e');
      setState(() {
        neoInfo = ['Error during API call: $e'];
      });
    }
  }

  List<String> extractNeoInfo(Map<String, dynamic> jsonData) {
    List<String> neoList = [];

    try {
      Map<String, dynamic> neoData = jsonData['near_earth_objects']; 

      neoData.forEach((date, neos) {
        neoList.add('Date: $date');
        neos.forEach((neo) {
          neoList.add('Name: ${neo['name']}');
          neoList.add('Estimated Diameter (meters): ${neo['estimated_diameter_max']}');
          neoList.add('Closest Approach Date: ${neo['close_approach_data'][1]['close_approach_date_full']}');
          neoList.add('Miss Distance (kilometers): ${neo['close_approach_data'][1]['miss_distance']['kilometers']}');
          neoList.add('----------------------------------------');
        });
      });
    } catch (e) {
      print('Error during data extraction: $e');
      neoList = ['Error during data extraction: $e'];
    }

    return neoList;
  }
}
// intro.dart

import 'package:flutter/material.dart';
import 'disp.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController1,
              decoration: InputDecoration(labelText: 'Field 1'),
            ),
            TextField(
              controller: textController2,
              decoration: InputDecoration(labelText: 'Field 2'),
            ),
            ElevatedButton(
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Disp(
                     
                        start_date: textController1.text,
                        end_date: textController2.text,
                    )
                      
                    ),
                );
              },
              child: Text('Go to Disp'),
            ),
          ],
        ),
      ),
    );
  }
}

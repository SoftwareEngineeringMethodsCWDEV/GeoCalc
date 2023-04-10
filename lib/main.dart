import 'package:flutter/material.dart';
import 'calcPage.dart';
import 'drillholesPage.dart';

void main() {

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(),
        '/calc': (context) => const calcPage(),
        '/tubeList': (context)  => DrillholesPage(),

      },
    )
  );
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("GeoApp",
              style: TextStyle(fontSize: 20),),
              Container(
                width: 250,
                child: TextButton.icon(
                    style:ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/calc');
                    },

                  icon: const Icon(Icons.calculate),
                  label: const Text('Расчёт глубины скважины'),
                ),
              ),
              Container(
                width: 250,
                child: TextButton.icon(
                  style:ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/tubeList');
                  },
                  icon: const Icon(Icons.view_stream_rounded),
                  label: const Text('Замеры'),
                ),
              ),
            ],
          ),
        ),
      ));
  }
}

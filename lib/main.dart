import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  List<String> _countryName = List<String>();
  List<String> _countryFlag = List<String>();

  Future<void> getResponse() async {
    final Response response = await get(
        "https://www.worldometers.info/geography/flags-of-the-world/");
    final String data = response.body;
    final List<String> items = data.split('<a href="/img/flags');
    for (final String item in items.skip(1)) {
      const String countryTitlePattern = 'padding-top:10px">';
      _countryName.add(item.substring(
          item.indexOf(countryTitlePattern) + countryTitlePattern.length,
          item.indexOf('</div>')));
      _countryFlag
          .add('https://www.worldometers.info/img/flags${item.split('"')[0]}');
    }
  }

  @override
  void initState() {
    getResponse();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              itemCount: 195,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Image.network(
                      _countryFlag[index],
                      fit: BoxFit.fitHeight,
                    ),
                    Text(_countryName[index]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

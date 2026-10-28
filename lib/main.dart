import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prayer_time/models/prayer.dart';
import 'package:prayer_time/models/time.dart';

import './utils/date_time.dart';

void main() {
  runApp(const PrayerTimeApp());
}

class PrayerTimeApp extends StatelessWidget {
  const PrayerTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09232B),
        fontFamily: 'Roboto',
      ),
      home: const PrayerTimePage(),
    );
  }
}

class PrayerTimePage extends StatefulWidget {
  const PrayerTimePage({super.key});

  @override
  State<PrayerTimePage> createState() => _PrayerTimePageState();
}

class _PrayerTimePageState extends State<PrayerTimePage> {
  final List<(String, String)> _prayerTimes = [];

  bool isLoading = true;
  String currentTime = '';
  String currentCity = "Karachi";

  // Country and city controllers
  final TextEditingController _countryController = TextEditingController(
    text: "pakistan",
  );

  final TextEditingController _cityController = TextEditingController(
    text: "karachi",
  );

  Future<void> getPrayerInfo() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse(
      'https://prayertime.info/api/${_countryController.text.toLowerCase()}/${_cityController.text.toLowerCase()}.json',
    );
    print(url);

    final response = await http.get(url);
    final prayer = prayerFromJson(response.body);

    print(prayer.timezone);
    print(prayer.city);
    currentCity = prayer.city;

    Uri timeUrl = Uri.parse(
      'https://time.now/developer/api/timezone/${prayer.timezone}',
    );

    final jsonTime = await http.get(timeUrl);
    final time = timeFromJson(jsonTime.body);
    print(jsonTime.body);

    final today = prayer.days[0];
    _prayerTimes.clear();
    _prayerTimes.addAll([
      ('Fajr', today.fajr),
      ('Sunrise', today.sunrise),
      ('Dhuhr', today.dhuhr),
      ('Asr', today.asr),
      ('Maghrib', today.maghrib),
      ("Isha'A", today.isha),
    ]);

    setState(() {
      currentTime = DateFormat('EEEE, MMMM d, h:mm a').format(time.datetime);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPrayerInfo();
  }

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF09232B),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/mosque_background.png', fit: BoxFit.cover),

            !isLoading
                ? SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // App bar
                          SizedBox(
                            height: 46,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Text(
                                  'Prayer Time',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.search),
                                    color: const Color(0xFFAAA6C5),
                                    iconSize: 23,
                                    tooltip: 'Search',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 34,
                                      minHeight: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Country text field
                          TextField(
                            controller: _countryController,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              hintText: 'Enter country name',
                              prefixIcon: const Icon(
                                Icons.public,
                                color: Color(0xFFAAA6C5),
                              ),
                              filled: true,
                              fillColor: const Color(0xD9000C11),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // City text field
                          TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              hintText: 'Enter city name',
                              prefixIcon: const Icon(
                                Icons.location_city,
                                color: Color(0xFFAAA6C5),
                              ),
                              filled: true,
                              fillColor: const Color(0xD9000C11),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onEditingComplete: () {
                              getPrayerInfo();
                            },
                          ),

                          const SizedBox(height: 20),

                          // City name
                          Text(
                            currentCity,
                            style: TextStyle(
                              fontSize: 21,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Current date and time
                          Text(
                            currentTime,
                            style: const TextStyle(fontSize: 20, height: 1.1),
                          ),

                          const SizedBox(height: 73),

                          // Prayer times
                          for (var i = 0; i < _prayerTimes.length; i++) ...[
                            _PrayerTimeCard(
                              name: _prayerTimes[i].$1,
                              time: _prayerTimes[i].$2,
                              highlighted: i == 0,
                            ),
                            if (i < _prayerTimes.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}

class _PrayerTimeCard extends StatelessWidget {
  const _PrayerTimeCard({
    required this.name,
    required this.time,
    required this.highlighted,
  });

  final String name;
  final String time;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      padding: const EdgeInsets.symmetric(horizontal: 27),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xCC21164F) : const Color(0xD9000C11),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 21),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

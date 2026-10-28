// To parse this JSON data, do
//
//     final prayer = prayerFromJson(jsonString);

import 'dart:convert';

Prayer prayerFromJson(String str) => Prayer.fromJson(json.decode(str));

String prayerToJson(Prayer data) => json.encode(data.toJson());

class Prayer {
  final String city;
  final String slug;
  final String country;
  final String countrySlug;
  final double latitude;
  final double longitude;
  final String timezone;
  final double qiblaDegreesFromNorth;
  final String method;
  final String authority;
  final String madhab;
  final DateTime generated;
  final String license;
  final String source;
  final List<String> fields;
  final List<Day> days;

  Prayer({
    required this.city,
    required this.slug,
    required this.country,
    required this.countrySlug,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.qiblaDegreesFromNorth,
    required this.method,
    required this.authority,
    required this.madhab,
    required this.generated,
    required this.license,
    required this.source,
    required this.fields,
    required this.days,
  });

  factory Prayer.fromJson(Map<String, dynamic> json) => Prayer(
    city: json["city"],
    slug: json["slug"],
    country: json["country"],
    countrySlug: json["country_slug"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    timezone: json["timezone"],
    qiblaDegreesFromNorth: json["qibla_degrees_from_north"]?.toDouble(),
    method: json["method"],
    authority: json["authority"],
    madhab: json["madhab"],
    generated: DateTime.parse(json["generated"]),
    license: json["license"],
    source: json["source"],
    fields: List<String>.from(json["fields"].map((x) => x)),
    days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "slug": slug,
    "country": country,
    "country_slug": countrySlug,
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezone,
    "qibla_degrees_from_north": qiblaDegreesFromNorth,
    "method": method,
    "authority": authority,
    "madhab": madhab,
    "generated": generated.toIso8601String(),
    "license": license,
    "source": source,
    "fields": List<dynamic>.from(fields.map((x) => x)),
    "days": List<dynamic>.from(days.map((x) => x.toJson())),
  };
}

class Day {
  final DateTime date;
  final String imsak;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  Day({
    required this.date,
    required this.imsak,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    date: DateTime.parse(json["date"]),
    imsak: json["imsak"],
    fajr: json["fajr"],
    sunrise: json["sunrise"],
    dhuhr: json["dhuhr"],
    asr: json["asr"],
    maghrib: json["maghrib"],
    isha: json["isha"],
  );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "imsak": imsak,
    "fajr": fajr,
    "sunrise": sunrise,
    "dhuhr": dhuhr,
    "asr": asr,
    "maghrib": maghrib,
    "isha": isha,
  };
}

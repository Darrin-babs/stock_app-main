import "dart:convert";

class Stock {}

class MetaData {
  final String information;
  final String symbol;
  final DateTime lastRefreshed;
  final String outputSize;
  final String timeZone;

  MetaData({
    required this.information,
    required this.symbol,
    required this.lastRefreshed,
    required this.outputSize,
    required this.timeZone,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      information: json["1. Information"] as String,
      symbol: json["2. Symbol"] as String,
      lastRefreshed: DateTime.parse(json["3. Last Refreshed"] as String),
      outputSize: json["4. Output Size"] as String,
      timeZone: json["5. Time Zone"] as String,
    );
  }
}

class DailyBar {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  DailyBar({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory DailyBar.fromAlphaVantage(String dateStr, Map<String, dynamic> day) {
    double parseD(String key) => double.parse(day[key] as String);
    int parseI(String key) => int.parse(day[key] as String);

    return DailyBar(
      date: DateTime.parse(dateStr),
      open: parseD('1. open'),
      high: parseD('2. high'),
      low: parseD('3. low'),
      close: parseD('4. close'),
      volume: parseI('5. volume'),
    );
  }
}

class AlphaVantageDailyResponse {
  final MetaData meta;
  final List<DailyBar> bars;

  AlphaVantageDailyResponse({required this.meta, required this.bars});

  factory AlphaVantageDailyResponse.fromJson(Map<String, dynamic> json) {
    final metaJson = (json['Meta Data'] as Map).cast<String, dynamic>();

    final seriesJson = (json['Time Series (Daily)'] as Map)
        .cast<String, dynamic>();

    final bars = seriesJson.entries.map((e) {
      final dateStr = e.key;
      final day = (e.value as Map).cast<String, dynamic>();
      return DailyBar.fromAlphaVantage(dateStr, day);
    }).toList();

    bars.sort((a, b) => b.date.compareTo(a.date));

    return AlphaVantageDailyResponse(
      meta: MetaData.fromJson(metaJson),
      bars: bars,
    );
  }

  static AlphaVantageDailyResponse fromRawJson(String raw) =>
      AlphaVantageDailyResponse.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
}

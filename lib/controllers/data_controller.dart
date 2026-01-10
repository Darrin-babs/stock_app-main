import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/data_binding.dart';
import '../models/stock.dart';

// Controller responsible for fetching and exposing stock data.
class DataController extends GetxController {
  DataController({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'https://www.alphavantage.co';
  }

  final Dio _dio;

  final DataBinding<AlphaVantageDailyResponse> dailyBinding = DataBinding();
  final RxBool isLoading = false.obs;
  // Fetch daily time series for [symbol] using the provided [apiKey].
  // On success the parsed AlphaVantageDailyResponse is stored in
  // dailyBinding.value. Errors are rethrown to the caller.
  Future<void> fetchDaily(String symbol, {required String apiKey}) async {
    isLoading.value = true;
    try {
      final resp = await _dio.get(
        '/query',
        queryParameters: {
          'function': 'TIME_SERIES_DAILY',
          'symbol': symbol,
          'apikey': apiKey,
        },
      );

      if (resp.data is Map<String, dynamic>) {
        dailyBinding.value = AlphaVantageDailyResponse.fromJson(
            (resp.data as Map).cast<String, dynamic>());
      } else if (resp.data is String) {
        dailyBinding.value = AlphaVantageDailyResponse.fromRawJson(
            resp.data as String);
      } else {
        throw Exception('Unexpected response format');
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<DailyBar> get bars => dailyBinding.value?.bars ?? <DailyBar>[];
}

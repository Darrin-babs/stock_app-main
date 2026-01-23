import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/data_binding.dart';
import '../models/stock.dart';

class DataController extends GetxController {
  DataController({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'https://www.alphavantage.co';
  }

  final Dio _dio;

  final RxMap<String, DataBinding<AlphaVantageDailyResponse>> dailyBindings = <String, DataBinding<AlphaVantageDailyResponse>>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDaily('AAPL', apiKey: 'VRPSSNJICLSJMM08');
    fetchDaily('GOOGL', apiKey: 'VRPSSNJICLSJMM08');
    fetchDaily('AMZN', apiKey: 'VRPSSNJICLSJMM08');
  }

  Future<void> fetchDaily(String symbol, {required String apiKey}) async {
    if (dailyBindings.containsKey(symbol)) return;
    dailyBindings[symbol] = DataBinding();
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
        dailyBindings[symbol]!.value = AlphaVantageDailyResponse.fromJson(
            (resp.data as Map).cast<String, dynamic>());
      } else if (resp.data is String) {
        dailyBindings[symbol]!.value = AlphaVantageDailyResponse.fromRawJson(
            resp.data as String);
      } else {
        throw Exception('Unexpected response format');
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<DailyBar> getBars(String symbol) => dailyBindings[symbol]?.value?.bars ?? <DailyBar>[];
}

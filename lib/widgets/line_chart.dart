import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stocks/models/stock.dart';
import 'package:stocks/utils/app_colors.dart';

class StockDisplay extends StatefulWidget {
  const StockDisplay({
    super.key,
    required this.name,
    required this.symbol,
    this.price,
    this.growth,
    this.isUp,
    this.bars,
  });

  final String name;
  final String symbol;
  final String? price;
  final String? growth;
  final bool? isUp;
  final List<DailyBar>? bars;

  @override
  State<StockDisplay> createState() => _StockDisplayState();
}

class _StockDisplayState extends State<StockDisplay> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
    AppColors.contentColorRed,
    AppColors.contentColorPink,
  ];

  String get displayPrice {
    if (widget.bars != null && widget.bars!.isNotEmpty) {
      final latest = widget.bars!.first;
      return '\$${latest.close.toStringAsFixed(2)}';
    }
    return widget.price ?? '\$523.13';
  }

  String get displayGrowth {
    if (widget.bars != null && widget.bars!.isNotEmpty) {
      final latest = widget.bars!.first;
      final change = ((latest.close - latest.open) / latest.open) * 100;
      final sign = change >= 0 ? '+' : '';
      return '${sign}${change.toStringAsFixed(2)}%';
    }
    return widget.growth ?? '+12%';
  }

  bool get displayIsUp {
    if (widget.bars != null && widget.bars!.isNotEmpty) {
      final latest = widget.bars!.first;
      return latest.close > latest.open;
    }
    return widget.isUp ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: EdgeInsets.only(bottom: 1, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.cardDarkBackground,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: AspectRatio(aspectRatio: 0.9, child: LineChart(avgData())),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              widget.name,
              style: TextStyle(color: AppColors.primaryText, fontSize: 18),
            ),
          ),
          Positioned(
            top: 34,
            left: 10,
            child: Text(
              widget.symbol,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 10,
            child: Row(
              spacing: 5,
              children: [
                Text(
                  displayPrice,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  displayGrowth,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData avgData() {
    List<FlSpot> spots;
    if (widget.bars != null && widget.bars!.isNotEmpty) {
      final recentBars = widget.bars!.take(7).toList().reversed.toList();
      double minY = double.infinity;
      double maxY = double.negativeInfinity;
      for (var bar in recentBars) {
        minY = minY < bar.close ? minY : bar.close;
        maxY = maxY > bar.close ? maxY : bar.close;
      }
      spots = recentBars.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.close)).toList();
    } else {
      spots = const [
        FlSpot(0, 1.44),
        FlSpot(1, 1),
        FlSpot(1.8, 1.5),
        FlSpot(4, 2.60),
        FlSpot(6, 2.0),
        FlSpot(8, 1.94),
        FlSpot(11, 3.6),
      ];
    }
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(show: false, drawHorizontalLine: false),
      clipData: FlClipData(top: false, bottom: true, left: true, right: true),
      titlesData: FlTitlesData(
        show: false,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: displayIsUp
                ? [
                    ColorTween(
                      begin: gradientColors[0],
                      end: gradientColors[1],
                    ).lerp(0.2)!,
                    ColorTween(
                      begin: gradientColors[0],
                      end: gradientColors[1],
                    ).lerp(0.2)!,
                  ]
                : [
                    ColorTween(
                      begin: gradientColors[2],
                      end: gradientColors[3],
                    ).lerp(0.2)!,
                    ColorTween(
                      begin: gradientColors[2],
                      end: gradientColors[3],
                    ).lerp(0.2)!,
                  ],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: displayIsUp
                  ? [
                      ColorTween(
                        begin: gradientColors[0].withAlpha(50),
                        end: gradientColors[1].withAlpha(50),
                      ).lerp(0.2)!.withValues(alpha: 0.1),
                      ColorTween(
                        begin: gradientColors[0].withAlpha(50),
                        end: gradientColors[1].withAlpha(50),
                      ).lerp(0.2)!.withValues(alpha: 0.1),
                    ]
                  : [
                      ColorTween(
                        begin: gradientColors[2].withAlpha(50),
                        end: gradientColors[3].withAlpha(50),
                      ).lerp(0.2)!.withValues(alpha: 0.1),
                      ColorTween(
                        begin: gradientColors[2].withAlpha(50),
                        end: gradientColors[3].withAlpha(50),
                      ).lerp(0.2)!.withValues(alpha: 0.1),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}

class StockDisplayRow extends StatelessWidget {
  const StockDisplayRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        spacing: 5,
        children: [
          StockDisplay(name: "Apple", symbol: "AAPL", isUp: true),

          StockDisplay(name: "Apple", symbol: "AAPL", isUp: true),

          StockDisplay(name: "Apple", symbol: "AAPL", isUp: true),
        ],
      ),
    );
  }
}

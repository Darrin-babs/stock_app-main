import 'package:flutter/material.dart';
import 'package:stocks/utils/app_colors.dart';

class Transactions extends StatelessWidget {
  const Transactions({
    super.key,
    required this.stockIcon,
    required this.stockName,
    required this.stockSymbol,
    required this.stockPrice,
    required this.stockGrowth,
  });

  final String stockIcon;
  final String stockName;
  final String stockSymbol;
  final String stockPrice;
  final String stockGrowth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryText,
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: ClipOval(
                  child: Image.asset(stockIcon, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stockName,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    stockSymbol,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stockPrice,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              Text(
                stockGrowth,
                style: TextStyle(
                  color: AppColors.contentColorBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

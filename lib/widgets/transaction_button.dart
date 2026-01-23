import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocks/controllers/data_controller.dart';
import 'package:stocks/utils/app_colors.dart';

class TransactionButton extends StatelessWidget {
  const TransactionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.cardDarkBackground.withAlpha(220),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryText, size: 22),
            Text(
              title,
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionButtonRow extends StatelessWidget {
  const TransactionButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TransactionButton(
              icon: Icons.arrow_upward_rounded,
              title: "Send",
              onTap: () async {
                final controller = Get.put(DataController());
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await controller.fetchDaily(
                    'AAPL',
                    apiKey: 'VRPSSNJICLSJMM08',
                  );

                  final count = controller.getBars('AAPL').length;
                  messenger.showSnackBar(
                    SnackBar(content: Text('Fetched $count daily bars for AAPL')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Failed to fetch data: $e')),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: TransactionButton(
              icon: Icons.arrow_downward_rounded,
              title: "Receive",
              onTap: () {},
            ),
          ),
          Expanded(
            child: TransactionButton(
              icon: Icons.swap_horiz_rounded,
              title: "Swap",
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

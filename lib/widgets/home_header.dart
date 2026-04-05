import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Selamat Datang', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            SizedBox(height: 4),
            Text(
              'Halo, Pengguna!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: const Icon(Icons.notifications, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

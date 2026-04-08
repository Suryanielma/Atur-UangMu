import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/budget_settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  void _showNotification(BuildContext context) {
    if (!globalNotif) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifikasi dimatikan pada pengaturan budget.')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (globalAlert80)
              const Text('⚠️ Budget mendekati 80% dari batas bulanan Anda!', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            const Text('✅ Berhasil mencatat 2 pengeluaran hari ini.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

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
        GestureDetector(
          onTap: () => _showNotification(context),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.notifications, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

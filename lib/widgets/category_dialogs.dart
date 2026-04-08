import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoryDialog extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryDialog({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackgroundPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Lainnya',
              style: TextStyle(
                color: Color(0xFF333A44),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                _buildDialogItem(context, 'Listrik', Icons.flash_on),
                _buildDialogItem(context, 'Air', Icons.water_drop),
                _buildDialogItem(context, 'Pulsa', Icons.smartphone),
                _buildDialogItem(context, 'Asuransi', Icons.verified),
                _buildDialogItem(context, 'Belanja', Icons.shopping_bag),
                _buildDialogItem(context, 'Kategori\nBaru', Icons.add_circle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogItem(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title.contains('Kategori\nBaru')) {
          Navigator.pop(context); // Close the current dialog
          _showNewCategoryDialog(context);
        } else {
          onCategorySelected(title);
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4A5568), size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewCategoryDialog(
          onCategorySaved: onCategorySelected,
        );
      },
    );
  }
}

class NewCategoryDialog extends StatefulWidget {
  final Function(String) onCategorySaved;

  const NewCategoryDialog({
    super.key,
    required this.onCategorySaved,
  });

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  IconData? tempSelectedIcon;
  final TextEditingController nameController = TextEditingController();

  final List<IconData> iconOptions = [
    Icons.fastfood,
    Icons.sports_esports,
    Icons.movie,
    Icons.directions_car,
    Icons.home,
    Icons.school,
    Icons.pets,
    Icons.fitness_center,
    Icons.local_hospital,
    Icons.flight,
    Icons.weekend,
    Icons.computer,
    Icons.camera_alt,
    Icons.music_note,
    Icons.brush,
    Icons.local_cafe,
    Icons.restaurant,
    Icons.store,
    Icons.account_balance,
    Icons.work,
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackgroundPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori Baru',
              style: TextStyle(
                color: Color(0xFF333A44),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Ikon',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: iconOptions.length,
                itemBuilder: (context, index) {
                  final icon = iconOptions[index];
                  final isSelected = tempSelectedIcon == icon;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempSelectedIcon = icon;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.buttonBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.textPrimary : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? AppColors.textPrimary : Colors.grey[700],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nama Kategori',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Masukkan nama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBg,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (tempSelectedIcon != null && nameController.text.isNotEmpty) {
                    widget.onCategorySaved(nameController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
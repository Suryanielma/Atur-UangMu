import 'package:flutter/material.dart';
import '../services/options_service.dart';
import '../theme/app_colors.dart';
import '../services/budget_service.dart';

class CategoryDialog extends StatelessWidget {
  final Function(String) onCategorySelected;
  final bool isIncome;
  static final OptionsService _optionsService = OptionsService.instance;

  const CategoryDialog({super.key, required this.onCategorySelected, this.isIncome = false});

  @override
  Widget build(BuildContext context) {
    final categories = isIncome
        ? _optionsService.getIncomeCategories()
        : BudgetService.instance.getBudgetCategories().map((c) => c.name).toList();

    return Dialog(
      backgroundColor: AppColors.cardElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Lainnya',
              style: TextStyle(
                color: AppColors.textPrimary,
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
                ...categories.map((name) => _buildDialogItem(context, name, _resolveCategoryIcon(name))),
                if (isIncome)
                  _buildDialogItem(context, 'Kategori\nBaru', Icons.add_circle, isCreateAction: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogItem(BuildContext context, String title, IconData icon, {bool isCreateAction = false}) {
    return GestureDetector(
      onTap: () {
        if (isCreateAction) {
          Navigator.pop(context);
          _showNewCategoryDialog(context);
        } else {
          onCategorySelected(title);
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  IconData _resolveCategoryIcon(String categoryName) {
    if (!isIncome && categoryName != 'Lainnya') {
      try {
        final found = BudgetService.instance.getBudgetCategories().firstWhere((c) => c.name == categoryName);
        return found.icon;
      } catch (_) {}
    }
    final lower = categoryName.toLowerCase();
    if (lower.contains('gaji')) return Icons.work_outline_rounded;
    if (lower.contains('bonus')) return Icons.card_giftcard_rounded;
    if (lower.contains('investasi')) return Icons.show_chart_rounded;
    if (lower.contains('lain')) return Icons.more_horiz_rounded;
    if (lower.contains('listrik')) return Icons.flash_on;
    if (lower.contains('air')) return Icons.water_drop;
    if (lower.contains('pulsa')) return Icons.smartphone;
    if (lower.contains('asuransi')) return Icons.verified;
    if (lower.contains('belanja')) return Icons.shopping_bag;
    return Icons.category;
  }

  void _showNewCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => NewCategoryDialog(
        isIncome: isIncome,
        onCategorySaved: onCategorySelected,
      ),
    );
  }
}

class NewCategoryDialog extends StatefulWidget {
  final Function(String) onCategorySaved;
  final bool isIncome;

  const NewCategoryDialog({super.key, required this.onCategorySaved, this.isIncome = false});

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  IconData? tempSelectedIcon;
  final TextEditingController nameController = TextEditingController();

  final List<IconData> iconOptions = [
    Icons.fastfood, Icons.sports_esports, Icons.movie, Icons.directions_car,
    Icons.home, Icons.school, Icons.pets, Icons.fitness_center,
    Icons.local_hospital, Icons.flight, Icons.weekend, Icons.computer,
    Icons.camera_alt, Icons.music_note, Icons.brush, Icons.local_cafe,
    Icons.restaurant, Icons.store, Icons.account_balance, Icons.work,
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori Baru',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Ikon',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                    onTap: () => setState(() => tempSelectedIcon = icon),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.roseBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.rose : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? AppColors.rose : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Nama Kategori',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardBackground,
                hintText: 'Masukkan nama',
                hintStyle: const TextStyle(color: AppColors.textHint),
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
                  backgroundColor: AppColors.rose,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (tempSelectedIcon != null && nameController.text.isNotEmpty) {
                    final categoryName = nameController.text.trim();
                    if (widget.isIncome) {
                      OptionsService.instance.addExpenseCategory(categoryName);
                    } else {
                      BudgetService.instance.addBudgetCategory(name: categoryName, limitAmount: 0);
                    }
                    widget.onCategorySaved(categoryName);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
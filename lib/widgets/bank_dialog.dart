import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/options_service.dart';
import '../theme/app_colors.dart';

class BankDialog extends StatefulWidget {
  final Function(String) onBankSelected;

  const BankDialog({super.key, required this.onBankSelected});

  @override
  State<BankDialog> createState() => _BankDialogState();
}

class _BankDialogState extends State<BankDialog> {
  static final OptionsService _optionsService = OptionsService.instance;
  static final InMemoryDataStore _store = InMemoryDataStore.instance;

  String _searchQuery = '';

  List<String> _filterBanks(List<String> banks) {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) return banks;
    return banks.where((bank) => bank.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final banks = _filterBanks(_optionsService.getBankOptions());
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardElevated,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: AppColors.textHint),
                      hintText: 'Cari Bank....',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddBankDialog(context),
                    icon: const Icon(Icons.add, color: AppColors.rose),
                    label: const Text(
                      'Tambah Bank',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: banks.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Bank tidak ditemukan',
                              style: TextStyle(color: AppColors.textHint),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: banks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildBankItem(banks[index], context),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankItem(String name, BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onBankSelected(name);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.sandBg,
              radius: 20,
              child: const Icon(Icons.account_balance, color: AppColors.sand, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  void _showAddBankDialog(BuildContext context) {
    String newBankName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  'Tambah Bank',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Nama Bank',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    hintText: 'Masukkan nama bank',
                    hintStyle: const TextStyle(color: AppColors.textHint),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => newBankName = value,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (newBankName.trim().isNotEmpty) {
                        final bankName = newBankName.trim();
                        _optionsService.addBankOption(bankName);
                        widget.onBankSelected(bankName);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Simpan',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

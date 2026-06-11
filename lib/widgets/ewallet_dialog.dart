import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/options_service.dart';
import '../theme/app_colors.dart';

class EWalletDialog extends StatefulWidget {
  final Function(String) onEWalletSelected;

  const EWalletDialog({super.key, required this.onEWalletSelected});

  @override
  State<EWalletDialog> createState() => _EWalletDialogState();
}

class _EWalletDialogState extends State<EWalletDialog> {
  static final OptionsService _optionsService = OptionsService.instance;
  static final InMemoryDataStore _store = InMemoryDataStore.instance;

  String _searchQuery = '';

  List<String> _filterEWallets(List<String> eWallets) {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) return eWallets;
    return eWallets.where((wallet) => wallet.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final eWallets = _filterEWallets(_optionsService.getEWalletOptions());
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
                      hintText: 'Cari E-Wallet....',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEWalletDialog(context),
                    icon: const Icon(Icons.add, color: AppColors.rose),
                    label: const Text(
                      'Tambah E-Wallet',
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: eWallets.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'E-Wallet tidak ditemukan',
                              style: TextStyle(color: AppColors.textHint),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: eWallets.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildEWalletItem(eWallets[index], context),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEWalletItem(String name, BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onEWalletSelected(name);
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
              backgroundColor: AppColors.roseBg,
              radius: 20,
              child: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.rose,
                size: 20,
              ),
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

  void _showAddEWalletDialog(BuildContext context) {
    String newEWalletName = '';
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
                  'Tambah E-Wallet',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Nama E-Wallet',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    hintText: 'Masukkan nama E-Wallet',
                    hintStyle: const TextStyle(color: AppColors.textHint),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => newEWalletName = value,
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
                      if (newEWalletName.trim().isNotEmpty) {
                        final walletName = newEWalletName.trim();
                        _optionsService.addEWalletOption(walletName);
                        widget.onEWalletSelected(walletName);
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

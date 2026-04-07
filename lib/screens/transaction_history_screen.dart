import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String searchQuery = '';
  String activeFilter = '';

  // Data Dummy berdasarkan gambar
  final List<Map<String, dynamic>> dummyTransactions = [
    {
      'title': 'Belanja Groceries',
      'category': 'Makanan & Minuman',
      'time': '14:30',
      'amount': -125000,
      'group': 'Hari Ini',
      'icon': Icons.shopping_cart,
      'iconBg': const Color(0xFFDFF1FF),
      'iconColor': const Color(0xFF4C87F4),
    },
    {
      'title': 'Transfer dari Ayah',
      'category': 'Uang Saku',
      'time': '10:15',
      'amount': 500000,
      'group': 'Hari Ini',
      'icon': Icons.account_balance_wallet,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': AppColors.incomeGreen,
    },
    {
      'title': 'Steam Games',
      'category': 'Hiburan',
      'time': '09:45',
      'amount': -75000,
      'group': 'Hari Ini',
      'icon': Icons.gamepad,
      'iconBg': const Color(0xFFF1E4FC),
      'iconColor': const Color(0xFF8B42F2),
    },
    {
      'title': 'Bensin Motor',
      'category': 'Transportasi',
      'time': '18:20',
      'amount': -25000,
      'group': 'Kemarin',
      'icon': Icons.directions_car,
      'iconBg': const Color(0xFFFDF0DF),
      'iconColor': const Color(0xFFF09028),
    },
    {
      'title': 'Makan Siang',
      'category': 'Makanan & Minuman',
      'time': '12:30',
      'amount': -35000,
      'group': 'Kemarin',
      'icon': Icons.restaurant,
      'iconBg': const Color(0xFFFEE7E4),
      'iconColor': AppColors.expenseRed,
    },
    {
      'title': 'Gaji Freelance',
      'category': 'Pekerjaan',
      'time': '09:00',
      'amount': 750000,
      'group': 'Kemarin',
      'icon': Icons.work,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': AppColors.incomeGreen,
    },
    {
      'title': 'Listrik Bulanan',
      'category': 'Tagihan',
      'time': '3 hari lalu',
      'amount': -150000,
      'group': 'Minggu Ini',
      'icon': Icons.home,
      'iconBg': const Color(0xFFDFF1FF),
      'iconColor': const Color(0xFF4C87F4),
    },
    {
      'title': 'Buku Kuliah',
      'category': 'Pendidikan',
      'time': '4 hari lalu',
      'amount': -85000,
      'group': 'Minggu Ini',
      'icon': Icons.book,
      'iconBg': const Color(0xFFFEF3CB),
      'iconColor': const Color(0xFFD6A200),
    },
    {
      'title': 'Hadiah Ulang Tahun',
      'category': 'Lainnya',
      'time': '5 hari lalu',
      'amount': 200000,
      'group': 'Minggu Ini',
      'icon': Icons.card_giftcard,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': AppColors.incomeGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Implementasi filter & pencarian sederhana
    final filteredTransactions = dummyTransactions.where((tx) {
      final matchesQuery =
          tx['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          tx['category'].toLowerCase().contains(searchQuery.toLowerCase());
      
      // Filter sederhana (jika label cocok dengan group / kategori)
      final matchesFilter = activeFilter.isEmpty || 
          tx['group'] == activeFilter || 
          tx['category'] == activeFilter;

      return matchesQuery && matchesFilter;
    }).toList();

    // Grouping ulang berdasarkan grup
    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var tx in filteredTransactions) {
      if (!groupedData.containsKey(tx['group'])) {
        groupedData[tx['group']] = [];
      }
      groupedData[tx['group']]!.add(tx);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman Home
          },
        ),
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: Summary Cards (Pemasukan, Pengeluaran)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    _buildSummaryCard(
                      title: 'Pemasukan',
                      amount: 'Rp 2.500.000',
                      subtitle: 'Total Masuk',
                      isIncome: true,
                      backgroundColor: const Color(0xFFE2FBEA), // Light mint green
                      iconColor: AppColors.incomeGreen,
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      title: 'Pengeluaran',
                      amount: 'Rp 1.850.000',
                      subtitle: 'Total Keluar',
                      isIncome: false,
                      backgroundColor: const Color(0xFFFDF0DF), // White-ish/Light peach
                      iconColor: AppColors.expenseRed,
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Cari transaksi...',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Bulan Ini', Icons.calendar_today),
                          const SizedBox(width: 8),
                          _buildFilterChip('Kategori', Icons.filter_alt),
                          const SizedBox(width: 8),
                          _buildFilterChip('Pembayaran', Icons.credit_card),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Transaction List Grouped by Date
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final groupKey = groupedData.keys.elementAt(index);
                  final items = groupedData[groupKey]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupKey,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...items.map((tx) => _buildTransactionItem(tx)).toList(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
                childCount: groupedData.keys.length,
              ),
            ),

            // Load More Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBgPurple,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Muat Lebih Banyak',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String subtitle,
    required bool isIncome,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: iconColor,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeFilter = isActive ? '' : label; // toggle filter
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    bool isIncome = (tx['amount'] as int) > 0;
    
    // Format mata uang sederhana
    String amountFormatted = ((tx['amount'] as int).abs()).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.'
    );
    String displayAmount = '${isIncome ? '+' : '-'}Rp $amountFormatted';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundPurple, // light purple card background
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: tx['iconBg'],
                blurRadius: 4,
                spreadRadius: 2,
              )
            ]
          ),
          child: Icon(
            tx['icon'],
            color: tx['iconColor'],
            size: 24,
          ),
        ),
        title: Text(
          tx['title'],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          '${tx['category']} • ${tx['time']}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          displayAmount,
          style: TextStyle(
            color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        currentIndex: 2, // 2 = Riwayat
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Kembali ke Beranda / tutup layar Riwayat
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}


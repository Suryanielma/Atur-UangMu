import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'add_transaction_screen.dart';
import 'transaction_history_screen.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

// Global settings for demo purposes
bool globalNotif = true;
bool globalAlert80 = true;
bool globalReset = true;
double globalBudgetUtama = 5000000;

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final Color warnaBackground = const Color.fromARGB(255, 246, 171, 219);
  final Color warnaKartu = const Color(0xFFFCEEF6); // Pink sangat muda untuk kartu
  final Color unguTua = const Color(0xFF402273); // Warna judul & teks utama
  final Color pinkAksen = const Color(0xFFFE5897); // Warna tombol & switch
  final Color hijauSisa = const Color(0xFF34A853); // Warna teks sisa (Hijau)
  final Color merahAlert = const Color(0xFFFF5252); // Warna bar hiburan

  // --- DATA STATE ---
  final double _totalPakaiGlobal = 2650000.0; // Anggap total pengeluaran sudah segini untuk demo

  List<Map<String, dynamic>> _kategoriData = [];

  @override
  void initState() {
    super.initState();
    _kategoriData = [
      {"nama": "Makanan", "limit": 1000000.0, "pakai": 650000.0, "warnaBar": const Color(0xFFFF8C42), "ikon": Icons.fastfood},
      {"nama": "Transport", "limit": 500000.0, "pakai": 320000.0, "warnaBar": const Color(0xFF2196F3), "ikon": Icons.drive_eta},
      {"nama": "Hiburan", "limit": 300000.0, "pakai": 280000.0, "warnaBar": const Color(0xFFFF5252), "ikon": Icons.face},
      {"nama": "Pakaian", "limit": 400000.0, "pakai": 120000.0, "warnaBar": const Color(0xFF4CAF50), "ikon": Icons.checkroom},
    ];
  }

  void _showEditCategoryDialog(int index) {
    TextEditingController controller = TextEditingController(text: _kategoriData[index]['limit'].toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Budget ${_kategoriData[index]['nama']}", style: TextStyle(color: unguTua, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: "Rp "),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _kategoriData[index]['limit'] = double.tryParse(controller.text) ?? _kategoriData[index]['limit'];
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: pinkAksen),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    TextEditingController controller = TextEditingController(text: globalBudgetUtama.toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Budget", style: TextStyle(color: unguTua, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: "Rp "),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                globalBudgetUtama = double.tryParse(controller.text) ?? globalBudgetUtama;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: pinkAksen),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBackground,
      appBar: AppBar(
        title: Text("Pengaturan Budget", style: TextStyle(color: unguTua, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: unguTua),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardUtama(),
            const SizedBox(height: 25),

            _header("Budget per Kategori", "+ Tambah"),
            const SizedBox(height: 15),
            _buildListKategori(),
            
            const SizedBox(height: 15),
            _header("Pengaturan", ""),
            const SizedBox(height: 15),

            _kartuPengaturan(),
            const SizedBox(height: 30),

            _tombolSimpan(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // --- KOMPONEN UI ---
  Widget _cardUtama() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: warnaKartu, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.white54, child: Icon(Icons.calendar_today, color: Color(0xFF402273))),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Budget Bulanan", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Total limit pengeluaran", style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _showEditDialog,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.grey, elevation: 0),
                child: const Text("Edit"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text("Rp ${globalBudgetUtama.toInt()}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: unguTua)),
          Text("Sisa: Rp ${(globalBudgetUtama - _totalPakaiGlobal).toInt()}", style: TextStyle(color: globalBudgetUtama - _totalPakaiGlobal < 0 ? merahAlert : Colors.redAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: (_totalPakaiGlobal / globalBudgetUtama).clamp(0.0, 1.0), backgroundColor: Colors.white, valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 8),
        ],
      ),
    );
  }

  String _formatRp(double value) {
    return "Rp ${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  Widget _buildListKategori() {
    return Column(
      children: List.generate(_kategoriData.length, (index) {
        var cat = _kategoriData[index];
        double limit = cat['limit'];
        double pakai = cat['pakai'];
        double sisa = limit - pakai;
        double persen = limit == 0 ? 0 : (pakai / limit).clamp(0.0, 1.0);
        bool isGreen = sisa >= 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _itemKategori(
            cat['nama'],
            _formatRp(limit),
            _formatRp(pakai),
            _formatRp(sisa),
            persen,
            cat['warnaBar'],
            cat['ikon'],
            isGreen,
            index,
          ),
        );
      }),
    );
  }

  Widget _itemKategori(String nama, String limit, String pakai, String sisa, double persen, Color warnaBar, IconData ikon, bool isGreen, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: warnaKartu, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white, child: Icon(ikon, color: const Color(0xFFFFA559))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(nama, style: TextStyle(fontWeight: FontWeight.bold, color: unguTua)),
                Text(limit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ])),
              GestureDetector(
                onTap: () => _showEditCategoryDialog(index),
                child: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Terpakai", style: TextStyle(color: Colors.grey, fontSize: 13)),
            Text(pakai, style: TextStyle(fontWeight: FontWeight.bold, color: unguTua)),
          ]),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: persen, backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation(warnaBar), minHeight: 8),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Sisa: $sisa", style: TextStyle(color: isGreen ? hijauSisa : merahAlert, fontWeight: FontWeight.bold, fontSize: 13)),
            Text("${(persen * 100).toInt()}%", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
        ],
      ),
    );
  }

  Widget _kartuPengaturan() {
    return Container(
      decoration: BoxDecoration(color: warnaKartu, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _tilePengaturan(Icons.notifications, "Notifikasi Budget", "Peringatan saat mendekati limit", globalNotif, (v) => setState(() => globalNotif = v)),
          _tilePengaturan(Icons.warning_amber_rounded, "Peringatan 80%", "Alert saat budget mencapai 80%", globalAlert80, (v) => setState(() => globalAlert80 = v)),
          _tilePengaturan(Icons.refresh, "Reset Otomatis", "Reset budget setiap awal bulan", globalReset, (v) => setState(() => globalReset = v)),
        ],
      ),
    );
  }

  Widget _tilePengaturan(IconData ikon, String t, String s, bool v, Function(bool) onc) {
    return SwitchListTile(
      secondary: CircleAvatar(backgroundColor: Colors.white, child: Icon(ikon, color: const Color(0xFFFFA559))),
      title: Text(t, style: TextStyle(fontWeight: FontWeight.bold, color: unguTua, fontSize: 14)),
      subtitle: Text(s, style: const TextStyle(fontSize: 11)),
      value: v,
      onChanged: onc,
      activeColor: pinkAksen,
    );
  }

  Widget _tombolSimpan() {
    return Container(
      width: double.infinity, height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [pinkAksen, unguTua]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengaturan Berhasil Disimpan!"))),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: const Text("Simpan Pengaturan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _header(String t, String a) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(t, style: TextStyle(fontWeight: FontWeight.bold, color: unguTua, fontSize: 16)),
      Text(a, style: TextStyle(color: pinkAksen, fontWeight: FontWeight.bold, fontSize: 12)),
    ]);
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed, 
        currentIndex: 3, 
        selectedItemColor: AppColors.textPrimary, 
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Transaksi"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Budget"),
        ],
      ),
    );
  }
}
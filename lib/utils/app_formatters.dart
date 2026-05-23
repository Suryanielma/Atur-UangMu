String formatRupiah(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
  }

  final signPrefix = value < 0 ? '- ' : '';
  return '${signPrefix}Rp ${buffer.toString()}';
}

String formatSignedRupiah(int value) {
  final sign = value >= 0 ? '+ ' : '- ';
  return '$sign${formatRupiah(value.abs())}';
}

String formatCompactRupiah(int value) {
  if (value >= 1000000) {
    final million = value / 1000000;
    final hasDecimal = million != million.roundToDouble();
    final text = hasDecimal
        ? million
              .toStringAsFixed(2)
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), '')
        : million.toStringAsFixed(0);
    return 'Rp ${text}M';
  }

  if (value >= 1000) {
    final thousand = value / 1000;
    final hasDecimal = thousand != thousand.roundToDouble();
    final text = hasDecimal
        ? thousand
              .toStringAsFixed(2)
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), '')
        : thousand.toStringAsFixed(0);
    return 'Rp ${text}K';
  }

  return formatRupiah(value);
}

String formatDateLabel(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final day = date.day.toString().padLeft(2, '0');
  final month = months[date.month - 1];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '$day $month ${date.year}, $hour:$minute';
}

String formatDateInput(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

const _monthNamesFull = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String formatMonthYear(DateTime date) {
  return '${_monthNamesFull[date.month - 1]} ${date.year}';
}

String formatMonthYearKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  return '${date.year}-$month';
}

DateTime? parseMonthYearKey(String value) {
  final parts = value.split('-');
  if (parts.length != 2) {
    return null;
  }

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  if (year == null || month == null || month < 1 || month > 12) {
    return null;
  }

  return DateTime(year, month);
}

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

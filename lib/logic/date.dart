String generateMmDdDate(double day) {
      final date = DateTime.now().add(Duration(days: day.toInt()));
      final dayString = date.day.toString().padLeft(2, '0');
      final monthString = date.month.toString().padLeft(2, '0');
      return '$dayString/$monthString';
    }
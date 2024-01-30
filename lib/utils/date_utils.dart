class DateTimeUtils {
  static String formatDateTime(DateTime dateTime) {
    // Format DateTime as a string (e.g., "2024-01-28 14:30")
    return "${dateTime.year}-${_formatNumber(dateTime.month)}-${_formatNumber(dateTime.day)} "
        "${_formatNumber(dateTime.hour)}:${_formatNumber(dateTime.minute)}";
  }

  static String formatTime(DateTime dateTime) {
    // Format DateTime as a time (e.g., "14:30")
    return "${_formatNumber(dateTime.hour)}:${_formatNumber(dateTime.minute)}";
  }

  static String _formatNumber(int number) {
    // Format a single-digit number with leading zero (e.g., "05")
    return number.toString().padLeft(2, '0');
  }

  static bool isFutureDate(DateTime date) {
    // Check if the given date is in the future
    final now = DateTime.now();
    return date.isAfter(now);
  }
}

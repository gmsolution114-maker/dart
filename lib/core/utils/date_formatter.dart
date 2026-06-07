import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _dateTimeFormat = DateFormat('MMM d, yyyy • h:mm a');
  static final _timeFormat = DateFormat('h:mm a');
  static final _relativeThreshold = const Duration(hours: 24);

  static String format(DateTime? dateTime) {
    if (dateTime == null) return '—';
    return _dateFormat.format(dateTime.toLocal());
  }

  static String formatWithTime(DateTime? dateTime) {
    if (dateTime == null) return '—';
    return _dateTimeFormat.format(dateTime.toLocal());
  }

  static String relative(DateTime? dateTime) {
    if (dateTime == null) return '—';
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return _dateFormat.format(local);
  }

  static String time(DateTime? dateTime) {
    if (dateTime == null) return '—';
    return _timeFormat.format(dateTime.toLocal());
  }
}

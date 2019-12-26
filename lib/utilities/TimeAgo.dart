class TimeAgo {
  String format(DateTime date,
      {String locale, DateTime clock, bool allowFromNow}) {
    final _allowFromNow = allowFromNow ?? false;
    final messages = EnShortMessages();
    final _clock = clock ?? DateTime.now();
    var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    String prefix, suffix;

    if (_allowFromNow && elapsed < 0) {
      elapsed = date.isBefore(_clock) ? elapsed : elapsed.abs();
      prefix = messages.prefixFromNow();
      suffix = messages.suffixFromNow();
    } else {
      prefix = messages.prefixAgo();
      suffix = messages.suffixAgo();
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45)
      result = messages.lessThanOneMinute(seconds.round());
    else if (seconds < 90)
      result = messages.aboutAMinute(minutes.round());
    else if (minutes < 45)
      result = messages.minutes(minutes.round());
    else if (minutes < 90)
      result = messages.aboutAnHour(minutes.round());
    else if (hours < 24)
      result = messages.hours(hours.round());
    else if (hours < 48)
      result = messages.aDay(hours.round());
    else if (days < 30)
      result = messages.days(days.round());
    else if (days < 60)
      result = messages.aboutAMonth(days.round());
    else if (days < 365)
      result = messages.months(months.round());
    else if (years < 2)
      result = messages.aboutAYear(months.round());
    else
      result = messages.years(years.round());

    return [prefix, result, suffix]
        .where((str) => str != null && str.isNotEmpty)
        .join(messages.wordSeparator());
  }
}

class EnShortMessages implements LookupMessages {
  String prefixAgo() => '';
  String prefixFromNow() => '';
  String suffixAgo() => '';
  String suffixFromNow() => '';
  String lessThanOneMinute(int seconds) => 'now';
  String aboutAMinute(int minutes) => '1min';
  String minutes(int minutes) => '${minutes}min';
  String aboutAnHour(int minutes) => '~1 \h';
  String hours(int hours) => '${hours}h';
  String aDay(int hours) => '~1d';
  String days(int days) => '${days}d';
  String aboutAMonth(int days) => '~1 mo';
  String months(int months) => '${months}mo';
  String aboutAYear(int year) => '~1yr';
  String years(int years) => '${years}yr';
  String wordSeparator() => ' ';
}

abstract class LookupMessages {
  String prefixAgo();
  String prefixFromNow();
  String suffixAgo();
  String suffixFromNow();
  String lessThanOneMinute(int seconds);
  String aboutAMinute(int minutes);
  String minutes(int minutes);
  String aboutAnHour(int minutes);
  String hours(int hours);
  String aDay(int hours);
  String days(int days);
  String aboutAMonth(int days);
  String months(int months);
  String aboutAYear(int year);
  String years(int years);
  String wordSeparator() => '';
}

// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

typedef CellBuilder<T extends Object?, S extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T, S>> event,
  bool isToday,
  bool isInMonth,
);

typedef OwnerTileBuilder<S extends Object?> = Widget Function(
  S owner,
);

typedef EventTileBuilder<T extends Object?, S extends Object?> = Widget
    Function(
  DateTime date,
  List<CalendarEventData<T, S>> events,
  Rect boundary,
  DateTime startDuration,
  DateTime endDuration,
);

typedef DetectorBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required double height,
  required double width,
  required double heightPerMinute,
  required MinuteSlotSize minuteSlotSize,
});

typedef WeekDayBuilder = Widget Function(
  int day,
);

typedef DateWidgetBuilder = Widget Function(DateTime date);

typedef HeaderTitleCallback = Future<void> Function(DateTime date);

typedef WeekNumberBuilder = Widget? Function(
  DateTime firstDayOfWeek,
);

typedef FullDayEventBuilder<T, S> = Widget Function(
    List<CalendarEventData<T, S>> events, DateTime date);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);
typedef DayCalendarPageChangeCallBack = void Function(
  DateTime date,
);

typedef PageChangeCallback = void Function(
  DateTime date,
  CalendarEventData event,
);

typedef StringProvider = String Function(DateTime date,
    {DateTime? secondaryDate});

typedef WeekPageHeaderBuilder = Widget Function(
  DateTime startDate,
  DateTime endDate,
);

typedef TileTapCallback<T extends Object?, S extends Object?> = void Function(
    CalendarEventData<T, S> event, DateTime date);

typedef CellTapCallback<T extends Object?, S extends Object?> = void Function(
    List<CalendarEventData<T, S>> events, DateTime date);

typedef DatePressCallback = void Function(DateTime date);

typedef DateTapCallback = void Function(DateTime date);

typedef EventFilter<T extends Object?, S extends Object?>
    = List<CalendarEventData<T, S>> Function(
        DateTime date, List<CalendarEventData<T, S>> events);

typedef CustomHourLinePainter = CustomPainter Function(
  Color lineColor,
  double lineHeight,
  double offset,
  double minuteHeight,
  bool showVerticalLine,
  double verticalLineOffset,
  LineStyle lineStyle,
  double dashWidth,
  double dashSpaceWidth,
  double emulateVerticalOffsetBy,
);

typedef TestPredicate<T> = bool Function(T element);

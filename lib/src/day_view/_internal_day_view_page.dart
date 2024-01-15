// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../components/_internal_components.dart';
import '../components/event_scroll_notifier.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../modals.dart';
import '../owner_view_configuration.dart';
import '../painters.dart';
import '../typedefs.dart';

/// Defines a single day page.
class InternalDayViewPage<T extends Object?, S extends Object?>
    extends StatelessWidget {
  /// Width of the page
  final double width;

  /// Height of the page.
  final double height;

  /// Date for which we are displaying page.
  final DateTime date;

  /// A builder that returns a widget to show event on screen.
  final EventTileBuilder<T, S> eventTileBuilder;

  /// A builder that returns a widget to show owner on screen.
  final OwnerTileBuilder<S> ownerTileBuilder;

  /// Controller for calendar
  final EventController<T, S> controller;

  /// A builder that builds time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Builds custom PressDetector widget
  final DetectorBuilder dayDetectorBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Custom painter for hour line.
  final CustomHourLinePainter hourLinePainter;

  /// Flag to display live time indicator.
  /// If true then indicator will be displayed else not.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  /// Height occupied by one minute of time span.
  final double heightPerMinute;

  /// Width of time line.
  final double timeLineWidth;

  /// Offset for time line widgets.
  final double timeLineOffset;

  /// Height occupied by one hour of time span.
  final double hourHeight;

  /// event arranger to arrange events.
  final EventArranger<T, S> eventArranger;

  /// Flag to display vertical line.
  final bool showVerticalLine;

  /// Offset  of vertical line.
  final double verticalLineOffset;

  /// Called when user taps on event tile.
  final CellTapCallback<T, S>? onTileTap;

  /// Called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Called when user taps on day view page.
  ///
  /// This callback will have a date parameter which
  /// will provide the time span on which user has tapped.
  ///
  /// Ex, User Taps on Date page with date 11/01/2022 and time span is 1PM to 2PM.
  /// then DateTime object will be  DateTime(2022,01,11,1,0)
  final DateTapCallback? onDateTap;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  /// Notifies if there is any event that needs to be visible instantly.
  final EventScrollConfiguration scrollNotifier;

  /// Display full day events.
  final FullDayEventBuilder<T, S> fullDayEventBuilder;

  /// Flag to display half hours.
  final bool showHalfHours;

  /// Flag to display quarter hours.
  final bool showQuarterHours;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings halfHourIndicatorSettings;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings quarterHourIndicatorSettings;

  final ScrollController scrollController;
  final ScrollController horizontalScrollController;
  final ScrollController scrollableHeaderScrollController;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// It indicates how to show owner tile
  final OwnerViewConfiguration ownerViewConfiguration;

  /// Defines a single day page.
  const InternalDayViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.width,
    required this.date,
    required this.eventTileBuilder,
    required this.ownerTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.hourLinePainter,
    required this.showLiveLine,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    required this.timeLineWidth,
    required this.timeLineOffset,
    required this.height,
    required this.hourHeight,
    required this.eventArranger,
    required this.verticalLineOffset,
    required this.onTileTap,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.minuteSlotSize,
    required this.scrollNotifier,
    required this.fullDayEventBuilder,
    required this.scrollController,
    required this.horizontalScrollController,
    required this.scrollableHeaderScrollController,
    required this.dayDetectorBuilder,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.halfHourIndicatorSettings,
    required this.quarterHourIndicatorSettings,
    required this.emulateVerticalOffsetBy,
    this.ownerViewConfiguration = const OwnerViewConfiguration(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullDayEventList = controller.getFullDayEvent(date);
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          fullDayEventList.isEmpty
              ? SizedBox.shrink()
              : fullDayEventBuilder(fullDayEventList, date),
          Container(
            height: ownerViewConfiguration.height,
            width: (controller.allOwners.length * _ownerWidth) + timeLineWidth,
            color: ownerViewConfiguration.backgroundColor,
            child: controller.allOwners.isNotEmpty
                ? ListView.separated(
                    controller: scrollableHeaderScrollController,
                    padding: EdgeInsetsDirectional.only(start: timeLineWidth),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.allOwners.length,
                    separatorBuilder: (context, index) =>
                        ownerViewConfiguration.divider ??
                        const SizedBox.shrink(),
                    itemBuilder: (context, index) => SizedBox(
                      width: _ownerWidth,
                      child: ownerTileBuilder(
                        controller.allOwners.elementAt(
                          index,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                width: width * 2,
                child: Row(
                  children: [
                    SizedBox(
                      width: timeLineOffset,
                    ),
                    SizedBox(
                      width: timeLineWidth,
                      child: Stack(
                        children: [
                          TimeLine(
                            height: height,
                            hourHeight: hourHeight,
                            timeLineBuilder: timeLineBuilder,
                            timeLineOffset: timeLineOffset,
                            timeLineWidth: timeLineWidth,
                            showHalfHours: showHalfHours,
                            showQuarterHours: showQuarterHours,
                            key: ValueKey(heightPerMinute),
                          ),
                          CustomPaint(
                            size: Size(width * 2, height),
                            painter: hourLinePainter(
                              hourIndicatorSettings.color,
                              hourIndicatorSettings.height,
                              hourIndicatorSettings.offset,
                              heightPerMinute,
                              showVerticalLine,
                              verticalLineOffset,
                              hourIndicatorSettings.lineStyle,
                              hourIndicatorSettings.dashWidth,
                              hourIndicatorSettings.dashSpaceWidth,
                              emulateVerticalOffsetBy,
                            ),
                          ),
                          if (showVerticalLine)
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Container(
                                width: 1,
                                height: height,
                                color: hourIndicatorSettings.color,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: height,
                          width: _totalOwnersWidthOrDefaultIfEmpty,
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(
                                    _totalOwnersWidthOrDefaultIfEmpty, height),
                                painter: hourLinePainter(
                                  hourIndicatorSettings.color,
                                  hourIndicatorSettings.height,
                                  hourIndicatorSettings.offset,
                                  heightPerMinute,
                                  showVerticalLine,
                                  verticalLineOffset,
                                  hourIndicatorSettings.lineStyle,
                                  hourIndicatorSettings.dashWidth,
                                  hourIndicatorSettings.dashSpaceWidth,
                                  emulateVerticalOffsetBy,
                                ),
                              ),
                              if (showHalfHours)
                                CustomPaint(
                                  size: Size(_totalOwnersWidthOrDefaultIfEmpty,
                                      height),
                                  painter: HalfHourLinePainter(
                                    lineColor: halfHourIndicatorSettings.color,
                                    lineHeight:
                                        halfHourIndicatorSettings.height,
                                    offset: halfHourIndicatorSettings.offset,
                                    minuteHeight: heightPerMinute,
                                    lineStyle:
                                        halfHourIndicatorSettings.lineStyle,
                                    dashWidth:
                                        halfHourIndicatorSettings.dashWidth,
                                    dashSpaceWidth: halfHourIndicatorSettings
                                        .dashSpaceWidth,
                                  ),
                                ),
                              if (showQuarterHours)
                                CustomPaint(
                                  size: Size(_totalOwnersWidthOrDefaultIfEmpty,
                                      height),
                                  painter: QuarterHourLinePainter(
                                    lineColor:
                                        quarterHourIndicatorSettings.color,
                                    lineHeight:
                                        quarterHourIndicatorSettings.height,
                                    offset: quarterHourIndicatorSettings.offset,
                                    minuteHeight: heightPerMinute,
                                    lineStyle:
                                        quarterHourIndicatorSettings.lineStyle,
                                    dashWidth:
                                        quarterHourIndicatorSettings.dashWidth,
                                    dashSpaceWidth: quarterHourIndicatorSettings
                                        .dashSpaceWidth,
                                  ),
                                ),
                              dayDetectorBuilder(
                                width: _totalOwnersWidthOrDefaultIfEmpty,
                                height: height,
                                heightPerMinute: heightPerMinute,
                                date: date,
                                minuteSlotSize: minuteSlotSize,
                              ),
                              controller.allOwners.isNotEmpty
                                  ? Row(
                                      children: controller.allOwners
                                          .map(
                                            (owner) => Expanded(
                                              child: EventGenerator<T, S>(
                                                height: height,
                                                date: date,
                                                onTileTap: onTileTap,
                                                eventArranger: eventArranger,
                                                events: controller
                                                    .getOwnerEventsOnDay(
                                                  date,
                                                  owner,
                                                  includeFullDayEvents: false,
                                                ),
                                                heightPerMinute:
                                                    heightPerMinute,
                                                eventTileBuilder:
                                                    eventTileBuilder,
                                                scrollNotifier: scrollNotifier,
                                                width: _ownerWidth -
                                                    hourIndicatorSettings
                                                        .offset -
                                                    verticalLineOffset,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : EventGenerator<T, S>(
                                      height: height,
                                      date: date,
                                      onTileTap: onTileTap,
                                      eventArranger: eventArranger,
                                      events: controller.getEventsOnDay(
                                        date,
                                        includeFullDayEvents: false,
                                      ),
                                      heightPerMinute: heightPerMinute,
                                      eventTileBuilder: eventTileBuilder,
                                      scrollNotifier: scrollNotifier,
                                      width: _ownerWidth -
                                          hourIndicatorSettings.offset -
                                          verticalLineOffset,
                                    ),
                              if (showLiveLine &&
                                  liveTimeIndicatorSettings.height > 0)
                                IgnorePointer(
                                  child: LiveTimeIndicator(
                                    liveTimeIndicatorSettings:
                                        liveTimeIndicatorSettings,
                                    width: _totalOwnersWidthOrDefaultIfEmpty,
                                    height: height,
                                    heightPerMinute: heightPerMinute,
                                    timeLineWidth: 0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _ownerWidth =>
      ownerViewConfiguration.widthPerOwner ?? _defaultOwnerWidth;

  double get _defaultOwnerWidth => width - timeLineWidth;

  double get _totalOwnersWidth => controller.allOwners.length * _ownerWidth;

  double get _totalOwnersWidthOrDefaultIfEmpty =>
      controller.allOwners.isNotEmpty ? _totalOwnersWidth : _ownerWidth;
}

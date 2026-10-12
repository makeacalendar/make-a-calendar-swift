# CalendarCraft Pro

**MakeACalendarCraft** is a small, offline Swift toolkit for Gregorian calendar grids, ISO weeks, US federal holiday planning, business-day calculations, and printable month exports. Calendar arithmetic uses validated civil dates and does not depend on the device time zone.

> Release candidate status: local source and package metadata are prepared for `0.1.0`. The GitHub repository has been created but source files have not yet been pushed. Do not install this package from GitHub or CocoaPods until a tagged release is published.

## Features in 0.1.0

- Validated Gregorian civil dates and leap-year arithmetic (years 1–9999).
- Sunday-first or Monday-first month grids and twelve-month year models.
- ISO week year, number, Monday, and Sunday.
- US federal holiday dates and adjacent weekday observances, including statutory effective-year cutoffs for MLK Day and Juneteenth.
- Configurable workweek; inclusive workday counts; positive/negative business-day addition.
- Accessible SwiftUI month grid for iOS 16 and macOS 13.
- Self-contained SVG and one-page vector PDF month exports.
- Foundation-only calculation APIs; no runtime network calls or third-party dependencies.

Holiday dates are planning data. This implementation does not model every historical statutory exception, agency closure, state holiday, or employer policy. Business-day counts include both interval endpoints; addition skips the start date.

## Install

### Swift Package Manager

```swift
.package(url: "https://github.com/makeacalendar/make-a-calendar-swift.git", from: "0.1.0")
```

Add `MakeACalendarCraft` to your target dependencies. The repository currently exists without source files; this URL will resolve to a package only after source is pushed.

### CocoaPods

```ruby
pod 'MakeACalendarCraft', '~> 0.1'
```

CocoaPods Trunk publication is pending. The podspec is in this repository; the above install command will work through the central specs CDN only after Trunk accepts the release.

## Quick start

```swift
import MakeACalendarCraft

let month = CalendarMonth(year: 2027, month: 1, weekStart: .monday)!
print(month.weeks.count) // complete Monday-first week rows

let jan1 = CivilDate(year: 2027, month: 1, day: 1)!
let isoWeek = ISOWeek(containing: jan1)

let observedFederalDates = Set(USFederalHolidays.holidays(in: 2027).map(\.date))
let businessDays = BusinessDayCalculator(holidays: observedFederalDates)
let dueDate = businessDays.adding(10, to: jan1)

let svg = try SVGCalendarRenderer.render(year: 2027, month: 1)
let pdf = try PDFCalendarRenderer.render(year: 2027, month: 1)
```

SwiftUI:

```swift
CalendarMonthView(year: 2027, month: 1) { selectedDate in
    print(selectedDate)
}
```

## Make a Calendar resources

The SDK is offline and does not call the website. These independent tools describe related workflows and can help developers compare product behavior:

- [Monthly calendars](https://make-a-calendar.com/monthly-calendars) and [yearly calendars](https://make-a-calendar.com/yearly-calendars/2027)
- [Business days](https://make-a-calendar.com/business-days-calculator) and [workday calendars](https://make-a-calendar.com/workday-calendar)
- [Date tools](https://make-a-calendar.com/date-tools), including [week numbers](https://make-a-calendar.com/week-number)
- [4-4-5 retail calendars](https://make-a-calendar.com/445-calendar), [4-5-4](https://make-a-calendar.com/454-calendar), and [5-4-4](https://make-a-calendar.com/544-calendar)
- [iCalendar generator](https://make-a-calendar.com/ical-generator) and [date converters](https://make-a-calendar.com/converters)

## Build and test

Requires Swift 5.9 or newer. The declared deployment targets are iOS 16 and macOS 13. The current build environment has Swift 6.4 command-line tools but no full Xcode installation; simulator builds and CocoaPods validation therefore require CI or a machine with Xcode and CocoaPods installed.

```sh
swift test
```

## Project status

Version `0.1.0` scope intentionally covers the first release: core Gregorian math, month/year grids, ISO weeks, federal holiday planning, business days, SwiftUI month UI, SVG and PDF. Fiscal 4-4-5 calendars, payroll/shift scheduling, recurrence rules, ICS export, extra date conversions, DocC hosting, screenshots, and a built Xcode showcase project remain future work. No publication or test result is claimed until verified.

## License

MIT. See [LICENSE](LICENSE).

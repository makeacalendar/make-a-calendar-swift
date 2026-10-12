# CalendarCraft Pro

**MakeACalendarCraft** is an offline Swift toolkit for deterministic Gregorian calendar grids, ISO weeks, US federal holiday planning, business-day calculations, and printable month exports. It has no network or third-party runtime dependency.

> **Pre-release:** Source is available in this repository. Version 0.1.0 has not been tagged, validated with Xcode/CocoaPods, or published to CocoaPods Trunk. Do not rely on the CocoaPods install command until a release appears on Trunk.

## Included in the current source

- Validated civil dates and Gregorian leap-year arithmetic for years 1–9999.
- Sunday-first or Monday-first month grids and yearly month models.
- ISO week number, week-year, Monday, and Sunday.
- US federal holiday dates and weekday observances, with effective-year handling for MLK Day and Juneteenth.
- Configurable workweek, inclusive business-day counts, and forward/backward business-day addition.
- SwiftUI month grid for iOS 16 and macOS 13.
- Self-contained SVG and one-page vector PDF month exports.

Holiday dates are planning data. Historical statutory exceptions, state holidays, agency closures, and employer policies are outside this implementation. Business-day counts include both endpoints; adding days skips the start date.

## Package setup

The package manifest and podspec are included, but a version tag and CocoaPods publication are not yet available. Once a verified 0.1.0 release is tagged, Swift Package Manager can use:

```swift
.package(url: "https://github.com/makeacalendar/make-a-calendar-swift.git", from: "0.1.0")
```

CocoaPods: `pod 'MakeACalendarCraft', '~> 0.1'` (pending Trunk acceptance).

## Quick example

```swift
import MakeACalendarCraft

let month = CalendarMonth(year: 2027, month: 1, weekStart: .monday)!
let date = CivilDate(year: 2027, month: 1, day: 1)!
let week = ISOWeek(containing: date)
let holidays = Set(USFederalHolidays.holidays(in: 2027).map(\.date))
let workdays = BusinessDayCalculator(holidays: holidays)
let dueDate = workdays.adding(10, to: date)
let svg = try SVGCalendarRenderer.render(year: 2027, month: 1)
let pdf = try PDFCalendarRenderer.render(year: 2027, month: 1)
```

## Build and validation

Run `swift test` with a compatible Swift/Xcode toolchain. Source parsing and podspec syntax have been checked locally, but the XCTest suite, Apple platform builds, simulator example, PDF output, and CocoaPods lint have not yet been run successfully. The current machine's Command Line Tools and installed SDK versions do not match, and full Xcode/CocoaPods tooling is unavailable.

## Scope and roadmap

This first source release covers calendar math, month/year grids, ISO weeks, federal holiday planning, business days, a SwiftUI month view, and SVG/PDF output. Fiscal retail calendars, payroll and rotating shifts, advanced recurrence, ICS export, additional date conversions, and a built Xcode showcase app remain future work.

The SDK is independent of the website. Related Make a Calendar tools include [monthly calendars](https://make-a-calendar.com/monthly-calendars), [yearly calendars](https://make-a-calendar.com/yearly-calendars/2027), [business days](https://make-a-calendar.com/business-days-calculator), [workday calendars](https://make-a-calendar.com/workday-calendar), and [date tools](https://make-a-calendar.com/date-tools).

## License

MIT. See [LICENSE](LICENSE).

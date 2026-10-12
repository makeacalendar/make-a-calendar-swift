# Product workflow mapping

The public Make a Calendar tools surface user workflows including [its main calendar creation site](https://make-a-calendar.com/), printable month/year layouts, workday counts, payroll and rotating-shift planning, fiscal and retail calendars, recurring dates, iCalendar, and date conversion. CalendarCraft 0.1.0 implements the cells marked **included** below independently, without requests to the website.

| Public workflow | Public inputs / outputs observed | SDK mapping | 0.1.0 |
| --- | --- | --- | --- |
| [Monthly calendars](https://make-a-calendar.com/monthly-calendars) | Month and year; printable calendar output | `CalendarMonth`, SVG/PDF | Included |
| [Yearly calendar](https://make-a-calendar.com/yearly-calendars/2027) | Year; twelve-month calendar | `CalendarYear` | Included (model only) |
| [Business days](https://make-a-calendar.com/business-days-calculator) | Range count or signed business-day offset; weekends and optional US observed federal holidays excluded | `BusinessDayCalculator`, `Workweek`, `USFederalHolidays` | Included |
| [Workday calendar](https://make-a-calendar.com/workday-calendar) | Year and workweek; visual workday grid | Month/year models + custom workweek | Partial (no yearly business-marking view) |
| [Pay periods](https://make-a-calendar.com/pay-period-calendar) and [biweekly calendar](https://make-a-calendar.com/biweekly-calendar) | Cadence, anchor/payday inputs; schedule dates | Future payroll module | Not included |
| [Rotating shifts](https://make-a-calendar.com/shift-calendar) | Pattern, cycle start and month; on/off shift days | Future shift module | Not included |
| [Fiscal calendar](https://make-a-calendar.com/fiscal-calendar) and [retail 4-4-5](https://make-a-calendar.com/445-calendar), [4-5-4](https://make-a-calendar.com/454-calendar), [5-4-4](https://make-a-calendar.com/544-calendar) | Fiscal start or retail year/pattern; period/week boundaries | Future fiscal module | Not included |
| [Week number](https://make-a-calendar.com/week-number) | Civil date/year; ISO week number and year | `ISOWeek` | Included |
| [Recurring dates](https://make-a-calendar.com/recurring-dates) | Starting date, recurrence cadence/interval and selected date rule; matching dates | Future recurrence module | Not included |
| [Deadline calculator](https://make-a-calendar.com/deadline-calculator) | Target/deadline and lead-time inputs; computed earlier date or milestone | Future date arithmetic module | Not included |
| [Julian date calendar](https://make-a-calendar.com/julian-calendar) | Civil year/date; day-of-year (`YYDDD`) and Julian/MJD-style values | Future conversion module | Not included |
| [iCalendar](https://make-a-calendar.com/ical-generator) and [holiday ICS](https://make-a-calendar.com/holiday-ical-calendar) | Event/calendar data; `.ics` output | Future ICS exporter | Not included |
| [Converters](https://make-a-calendar.com/converters), [Excel dates](https://make-a-calendar.com/excel-date-converter), [Windows FILETIME](https://make-a-calendar.com/filetime-converter), [Unix timestamps](https://make-a-calendar.com/unix-timestamp) | Epoch/serial values and conversion output | Future conversion module | Not included |
| [Blank calendar](https://make-a-calendar.com/pages/blank-calendar), [generator](https://make-a-calendar.com/calendar-generator), [multi-month](https://make-a-calendar.com/multi-month-calendar) | Paper/week-start/layout choice; undated grid, 12-month civil grid, or 2–18 month strip | Future blank/multi-month layouts | Not included |

`date-tools` links several of these workflows and documents date calculators. The site is the behavioral reference for public user-facing workflows; this library does not reuse its private implementation. Not every URL in the brief was independently opened in this research pass; the linked public pages and category listings above established the first-release scope.

## Reference package comparison

[BetaCalendarsPaperKit 0.1.1](https://cocoapods.org/pods/BetaCalendarsPaperKit) provides deterministic Gregorian civil dates/month grids, configurable week starts, blank grids, print geometry for paper sizes/orientations, SwiftUI month/blank views, vector PDF for month/year/planner sheets, DocC, examples, and a broad 1900–2100 test range. Its listing declares iOS 15+ and macOS 12+ and provides SwiftPM and CocoaPods instructions. CalendarCraft's initial scope differs through ISO week calculation, federal holiday dates, business-day math, and SVG export. The reference listing and its README/changelog/docs are public, but this project is an original implementation and does not copy that source.

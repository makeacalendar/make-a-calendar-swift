# ``MakeACalendarCraft``

Build deterministic Gregorian month grids, calculate ISO weeks and configurable business days, and export simple month calendars to SVG or PDF.

- ``CivilDate``
- ``CalendarMonth``
- ``CalendarYear``
- ``ISOWeek``
- ``USFederalHolidays``
- ``BusinessDayCalculator``
- ``CalendarMonthView``
- ``SVGCalendarRenderer``
- ``PDFCalendarRenderer``

The calculation model is offline and independent of Foundation time zones. Holiday dates follow the current federal holiday observance pattern, with 1986 and 2021 effective-year boundaries; applications requiring historic legal treatment should provide their own dates.

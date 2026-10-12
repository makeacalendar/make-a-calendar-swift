# Business-day calculations

`BusinessDayCalculator` accepts an ISO-weekday workweek and an explicit set of holidays. `count(from:through:)` counts both endpoints if they qualify. If the endpoints are reversed, it returns the negative count. `adding(_:to:)` starts after the input date, skips non-working weekdays and supplied holidays, and supports negative offsets.

For the common US federal planning pattern, pass the dates returned by `USFederalHolidays.holidays(in:)`. That helper supplies both legal holiday dates and weekday observances where the date falls on a weekend. It does not encode agency closures or every historical statutory exception.

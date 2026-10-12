import Foundation

public struct Holiday: Hashable, Sendable, Identifiable {
    public let name: String
    public let date: CivilDate
    public let isObserved: Bool
    public var id: String { "\(name)-\(date)" }
    public init(name: String, date: CivilDate, isObserved: Bool = false) { self.name = name; self.date = date; self.isObserved = isObserved }
}

/// Federal holidays established by US federal law. Dates are planning data, not a legal calendar.
public enum USFederalHolidays {
    public static func holidays(in year: Int, includeObserved: Bool = true) -> [Holiday] {
        guard (1...9999).contains(year) else { return [] }
        var fixed: [(String, Int, Int)] = [("New Year's Day",1,1),("Independence Day",7,4),("Veterans Day",11,11),("Christmas Day",12,25)]
        if year >= 1986 { fixed.append(("Birthday of Martin Luther King, Jr.", 0, 0)) }
        if year >= 2021 { fixed.append(("Juneteenth National Independence Day", 6, 19)) }
        var results = fixed.compactMap { name, m, d -> Holiday? in
            let date: CivilDate?
            if m == 0 { date = nthWeekday(weekday: 1, occurrence: 3, month: 1, year: year) }
            else { date = CivilDate(year: year, month: m, day: d) }
            guard let date else { return nil }
            return Holiday(name: name, date: date)
        }
        results += [
            nthWeekday(weekday: 1, occurrence: 3, month: 2, year: year).map { Holiday(name: "Washington's Birthday", date: $0) },
            lastWeekday(weekday: 1, month: 5, year: year).map { Holiday(name: "Memorial Day", date: $0) },
            nthWeekday(weekday: 1, occurrence: 1, month: 9, year: year).map { Holiday(name: "Labor Day", date: $0) },
            nthWeekday(weekday: 1, occurrence: 2, month: 10, year: year).map { Holiday(name: "Columbus Day", date: $0) },
            nthWeekday(weekday: 4, occurrence: 4, month: 11, year: year).map { Holiday(name: "Thanksgiving Day", date: $0) }
        ].compactMap { $0 }
        if includeObserved {
            let observed = results.compactMap { holiday -> Holiday? in
                let weekday = holiday.date.isoWeekday
                guard weekday == 6 || weekday == 7, let date = holiday.date.adding(days: weekday == 6 ? -1 : 1) else { return nil }
                return Holiday(name: holiday.name, date: date, isObserved: true)
            }
            results += observed
        }
        return results.sorted { $0.date == $1.date ? $0.name < $1.name : $0.date < $1.date }
    }
    private static func nthWeekday(weekday: Int, occurrence: Int, month: Int, year: Int) -> CivilDate? {
        guard let first = CivilDate(year: year, month: month, day: 1) else { return nil }
        return first.adding(days: (weekday - first.isoWeekday + 7) % 7 + (occurrence - 1) * 7)
    }
    private static func lastWeekday(weekday: Int, month: Int, year: Int) -> CivilDate? {
        guard let lastDay = CivilDate.daysInMonth(month, year: year), let last = CivilDate(year: year, month: month, day: lastDay) else { return nil }
        return last.adding(days: -((last.isoWeekday - weekday + 7) % 7))
    }
}

public struct Workweek: Sendable {
    /// ISO weekday numbers; defaults to Monday through Friday.
    public let workingWeekdays: Set<Int>
    public init(workingWeekdays: Set<Int> = [1, 2, 3, 4, 5]) { self.workingWeekdays = Set(workingWeekdays.filter { (1...7).contains($0) }) }
    public func isWorkingDay(_ date: CivilDate) -> Bool { workingWeekdays.contains(date.isoWeekday) }
}

public struct BusinessDayCalculator: Sendable {
    public let workweek: Workweek
    public let holidays: Set<CivilDate>
    public init(workweek: Workweek = Workweek(), holidays: Set<CivilDate> = []) { self.workweek = workweek; self.holidays = holidays }
    /// Counts qualifying dates in the closed interval, including both endpoints.
    public func count(from start: CivilDate, through end: CivilDate) -> Int {
        guard start <= end else { return -count(from: end, through: start) }
        var result = 0, cursor: CivilDate? = start
        while let date = cursor, date <= end {
            if workweek.isWorkingDay(date) && !holidays.contains(date) { result += 1 }
            cursor = date.adding(days: 1)
        }
        return result
    }
    /// Moves by workdays; the start date is not counted. Negative values move backward.
    public func adding(_ amount: Int, to start: CivilDate) -> CivilDate? {
        guard amount != Int.min else { return nil }
        if amount == 0 { return start }
        let direction = amount > 0 ? 1 : -1
        var remaining = abs(amount), cursor: CivilDate? = start
        while remaining > 0 {
            guard let next = cursor?.adding(days: direction) else { return nil }
            cursor = next
            if workweek.isWorkingDay(next) && !holidays.contains(next) { remaining -= 1 }
        }
        return cursor
    }
}

import Foundation

/// A Gregorian civil date with no time zone or time-of-day component.
public struct CivilDate: Hashable, Comparable, Codable, Sendable, CustomStringConvertible {
    public let year: Int
    public let month: Int
    public let day: Int

    public init?(year: Int, month: Int, day: Int) {
        guard (1...9999).contains(year), (1...12).contains(month),
              let maxDay = Self.daysInMonth(month, year: year), (1...maxDay).contains(day) else { return nil }
        self.year = year; self.month = month; self.day = day
    }

    public init?(_ iso8601: String) {
        let parts = iso8601.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3, let date = CivilDate(year: parts[0], month: parts[1], day: parts[2]) else { return nil }
        self = date
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }
    public var description: String { String(format: "%04d-%02d-%02d", year, month, day) }
    public var isLeapYear: Bool { Self.isLeapYear(year) }

    public static func isLeapYear(_ year: Int) -> Bool {
        year.isMultiple(of: 4) && (!year.isMultiple(of: 100) || year.isMultiple(of: 400))
    }
    public static func daysInMonth(_ month: Int, year: Int) -> Int? {
        guard (1...12).contains(month) else { return nil }
        switch month {
        case 2: return isLeapYear(year) ? 29 : 28
        case 4, 6, 9, 11: return 30
        default: return 31
        }
    }

    /// ISO weekday, where Monday is 1 and Sunday is 7.
    public var isoWeekday: Int {
        // Sakamoto's Gregorian weekday algorithm; result is 0=Sunday...6=Saturday.
        let offsets = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
        var y = year
        if month < 3 { y -= 1 }
        let sundayZero = (y + y/4 - y/100 + y/400 + offsets[month - 1] + day) % 7
        return sundayZero == 0 ? 7 : sundayZero
    }

    public func adding(days: Int) -> CivilDate? {
        guard let base = ordinalInCommonEra else { return nil }
        let (target, overflow) = base.addingReportingOverflow(days)
        guard !overflow else { return nil }
        return Self.fromOrdinal(target)
    }

    /// Days since 0001-01-01, useful for stable date arithmetic.
    private var ordinalInCommonEra: Int? {
        let y = year - 1
        let beforeYear = 365 * y + y/4 - y/100 + y/400
        let beforeMonth = (1..<month).reduce(0) { $0 + (Self.daysInMonth($1, year: year) ?? 0) }
        return beforeYear + beforeMonth + day - 1
    }
    private static func fromOrdinal(_ ordinal: Int) -> CivilDate? {
        guard ordinal >= 0 else { return nil }
        var lo = 1, hi = 10000
        while lo < hi {
            let mid = (lo + hi) / 2
            let start = 365 * (mid - 1) + (mid - 1)/4 - (mid - 1)/100 + (mid - 1)/400
            if start <= ordinal { lo = mid + 1 } else { hi = mid }
        }
        let year = lo - 1
        guard (1...9999).contains(year) else { return nil }
        var remainder = ordinal - (365 * (year - 1) + (year - 1)/4 - (year - 1)/100 + (year - 1)/400)
        var month = 1
        while let count = daysInMonth(month, year: year), remainder >= count { remainder -= count; month += 1 }
        return CivilDate(year: year, month: month, day: remainder + 1)
    }
}

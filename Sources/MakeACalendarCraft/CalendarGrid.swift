import Foundation

public enum WeekStart: Int, Codable, Sendable { case sunday = 0, monday = 1 }

/// A month grid containing complete weeks. Empty cells are `nil`.
public struct CalendarMonth: Equatable, Sendable {
    public let year: Int
    public let month: Int
    public let weekStart: WeekStart
    public let weeks: [[CivilDate?]]
    public var days: [CivilDate] { weeks.flatMap { $0.compactMap { $0 } } }

    public init?(year: Int, month: Int, weekStart: WeekStart = .sunday) {
        guard let count = CivilDate.daysInMonth(month, year: year), let first = CivilDate(year: year, month: month, day: 1) else { return nil }
        let offset = (first.isoWeekday % 7 - weekStart.rawValue + 7) % 7
        let cellCount = ((offset + count + 6) / 7) * 7
        var cells = Array<CivilDate?>(repeating: nil, count: cellCount)
        for day in 1...count { cells[offset + day - 1] = CivilDate(year: year, month: month, day: day) }
        self.year = year; self.month = month; self.weekStart = weekStart
        self.weeks = stride(from: 0, to: cellCount, by: 7).map { Array(cells[$0..<($0 + 7)]) }
    }
}

public struct CalendarYear: Equatable, Sendable {
    public let year: Int
    public let months: [CalendarMonth]
    public init?(year: Int, weekStart: WeekStart = .sunday) {
        guard (1...9999).contains(year) else { return nil }
        self.year = year
        self.months = (1...12).compactMap { CalendarMonth(year: year, month: $0, weekStart: weekStart) }
    }
}

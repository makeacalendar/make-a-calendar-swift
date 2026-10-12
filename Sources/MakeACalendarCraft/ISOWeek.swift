import Foundation

public struct ISOWeek: Equatable, Sendable {
    public let year: Int
    public let number: Int
    public let monday: CivilDate
    public var sunday: CivilDate? { monday.adding(days: 6) }

    public init(containing date: CivilDate) {
        let thursday = date.adding(days: 4 - date.isoWeekday)!
        self.year = thursday.year
        let jan4 = CivilDate(year: thursday.year, month: 1, day: 4)!
        let week1Monday = jan4.adding(days: 1 - jan4.isoWeekday)!
        self.monday = date.adding(days: 1 - date.isoWeekday)!
        self.number = ((self.monday.adding(days: 0)!.ordinalForWeek - week1Monday.ordinalForWeek) / 7) + 1
    }
}

private extension CivilDate {
    var ordinalForWeek: Int { let y = year - 1; return 365*y + y/4 - y/100 + y/400 + (1..<month).reduce(0) { $0 + (CivilDate.daysInMonth($1, year: year) ?? 0) } + day - 1 }
}

import XCTest
@testable import MakeACalendarCraft

final class MakeACalendarCraftTests: XCTestCase {
    func testCivilDateValidationAndLeapYears() {
        XCTAssertNil(CivilDate(year: 1900, month: 2, day: 29))
        XCTAssertNotNil(CivilDate(year: 2000, month: 2, day: 29))
        XCTAssertEqual(CivilDate(year: 2024, month: 2, day: 29)?.description, "2024-02-29")
        XCTAssertNil(CivilDate("2024-13-01"))
    }
    func testWeekdayAndArithmeticAcrossBoundaries() {
        let monday = CivilDate(year: 2024, month: 1, day: 1)!
        XCTAssertEqual(monday.isoWeekday, 1)
        XCTAssertEqual(monday.adding(days: -1)?.description, "2023-12-31")
        XCTAssertEqual(CivilDate(year: 2024, month: 2, day: 28)?.adding(days: 1)?.day, 29)
    }
    func testSundayAndMondayMonthGrids() {
        let sunday = CalendarMonth(year: 2024, month: 9)!
        XCTAssertEqual(sunday.weeks[0][0], CivilDate(year: 2024, month: 9, day: 1)!)
        XCTAssertEqual(sunday.days.count, 30)
        let monday = CalendarMonth(year: 2024, month: 9, weekStart: .monday)!
        XCTAssertNil(monday.weeks[0][0])
        XCTAssertEqual(monday.weeks[0][6], CivilDate(year: 2024, month: 9, day: 1)!)
        XCTAssertEqual(monday.weeks.count, 6)
    }
    func testYearContainsTwelveMonths() { XCTAssertEqual(CalendarYear(year: 2024)?.months.count, 12) }
    func testISOWeekAtYearBoundary() {
        let week = ISOWeek(containing: CivilDate(year: 2021, month: 1, day: 1)!)
        XCTAssertEqual(week.year, 2020); XCTAssertEqual(week.number, 53)
        XCTAssertEqual(week.monday.description, "2020-12-28")
    }
    func testUSFederalHolidayAndObservedDate() {
        let holidays = USFederalHolidays.holidays(in: 2021)
        XCTAssertTrue(holidays.contains { $0.name == "Juneteenth National Independence Day" && $0.date.description == "2021-06-19" })
        XCTAssertTrue(holidays.contains { $0.name == "Juneteenth National Independence Day" && $0.date.description == "2021-06-18" && $0.isObserved })
        XCTAssertEqual(USFederalHolidays.holidays(in: 2020).filter { $0.name == "Juneteenth National Independence Day" }.count, 0)
    }
    func testBusinessDayCountAndAddition() {
        let calc = BusinessDayCalculator(holidays: [CivilDate(year: 2024, month: 1, day: 1)!])
        XCTAssertEqual(calc.count(from: CivilDate(year: 2024, month: 1, day: 1)!, through: CivilDate(year: 2024, month: 1, day: 7)!), 4)
        XCTAssertEqual(calc.adding(1, to: CivilDate(year: 2023, month: 12, day: 29)!)?.description, "2024-01-02")
        XCTAssertEqual(calc.adding(-1, to: CivilDate(year: 2024, month: 1, day: 2)!)?.description, "2023-12-29")
        XCTAssertEqual(calc.count(from: CivilDate(year: 2024, month: 1, day: 7)!, through: CivilDate(year: 2024, month: 1, day: 1)!), -4)
    }
    func testCustomWorkweek() {
        let calc = BusinessDayCalculator(workweek: Workweek(workingWeekdays: [6, 7]))
        XCTAssertEqual(calc.count(from: CivilDate(year: 2024, month: 1, day: 1)!, through: CivilDate(year: 2024, month: 1, day: 7)!), 2)
    }
    func testSVGExport() throws {
        let svg = try SVGCalendarRenderer.render(year: 2024, month: 2)
        XCTAssertTrue(svg.hasPrefix("<svg")); XCTAssertTrue(svg.contains("2024-02")); XCTAssertTrue(svg.contains(">29</text>"))
        XCTAssertThrowsError(try SVGCalendarRenderer.render(year: 2024, month: 2, width: 10))
    }
    func testPDFExportProducesPDFDocument() throws {
        let data = try PDFCalendarRenderer.render(year: 2024, month: 2)
        XCTAssertTrue(String(decoding: data.prefix(8), as: UTF8.self).hasPrefix("%PDF-1.4"))
        XCTAssertTrue(String(decoding: data.suffix(20), as: UTF8.self).contains("%%EOF"))
    }
}

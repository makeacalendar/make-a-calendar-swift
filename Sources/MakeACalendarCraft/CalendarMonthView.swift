#if canImport(SwiftUI)
import SwiftUI

/// A compact, accessible SwiftUI month grid backed by the platform-independent calendar model.
@available(iOS 16.0, macOS 13.0, *)
public struct CalendarMonthView: View {
    private let calendarMonth: CalendarMonth
    private let selectedDate: CivilDate?
    private let onSelect: ((CivilDate) -> Void)?
    private let labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    public init?(year: Int, month: Int, weekStart: WeekStart = .sunday, selectedDate: CivilDate? = nil, onSelect: ((CivilDate) -> Void)? = nil) {
        guard let calendarMonth = CalendarMonth(year: year, month: month, weekStart: weekStart) else { return nil }
        self.calendarMonth = calendarMonth
        self.selectedDate = selectedDate
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 8) {
            Text(String(format: "%04d-%02d", calendarMonth.year, calendarMonth.month))
                .font(.headline).frame(maxWidth: .infinity, alignment: .leading)
            let weekdays = calendarMonth.weekStart == .sunday ? labels : Array(labels.dropFirst()) + [labels[0]]
            HStack(spacing: 0) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { _, label in
                    Text(label).font(.caption.weight(.semibold)).frame(maxWidth: .infinity)
                }
            }
            ForEach(Array(calendarMonth.weeks.enumerated()), id: \.offset) { _, week in
                HStack(spacing: 0) {
                    ForEach(Array(week.enumerated()), id: \.offset) { _, date in
                        Group {
                            if let date {
                                Button { onSelect?(date) } label: {
                                    Text("\(date.day)")
                                        .frame(maxWidth: .infinity, minHeight: 38)
                                        .background(selectedDate == date ? Color.accentColor : .clear, in: Circle())
                                        .foregroundStyle(selectedDate == date ? Color.white : Color.primary)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(date.description)
                            } else { Color.clear.frame(maxWidth: .infinity, minHeight: 38) }
                        }
                    }
                }
            }
        }
        .padding()
        .accessibilityElement(children: .contain)
    }
}
#endif

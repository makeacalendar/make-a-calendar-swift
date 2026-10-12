import SwiftUI
import MakeACalendarCraft

@available(iOS 16.0, macOS 13.0, *)
struct ContentView: View {
    @State private var selected: CivilDate?
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let month = CalendarMonthView(year: 2027, month: 1, weekStart: .sunday, selectedDate: selected, onSelect: { selected = $0 }) {
                        month
                    }
                    if let selected { Text("Selected: \(selected.description)").font(.subheadline) }
                    Link("Make a Calendar", destination: URL(string: "https://make-a-calendar.com/")!)
                    Text("Calendar data and calculations in this showcase are generated on-device.").font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }.navigationTitle("CalendarCraft")
        }
    }
}

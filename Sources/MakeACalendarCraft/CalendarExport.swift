import Foundation

public enum CalendarExportError: Error { case invalidMonth, invalidDimensions }

/// Renders a self-contained, dependency-free SVG month grid.
public enum SVGCalendarRenderer {
    public static func render(year: Int, month: Int, weekStart: WeekStart = .sunday, width: Int = 840, height: Int = 600, title: String? = nil) throws -> String {
        guard width >= 280, height >= 240 else { throw CalendarExportError.invalidDimensions }
        guard let grid = CalendarMonth(year: year, month: month, weekStart: weekStart) else { throw CalendarExportError.invalidMonth }
        let cellW = Double(width) / 7, headerH = 76.0, cellH = (Double(height) - headerH) / 6.0
        let weekdays = weekStart == .sunday ? ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"] : ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var s = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(width)\" height=\"\(height)\" viewBox=\"0 0 \(width) \(height)\">\n<rect width=\"100%\" height=\"100%\" fill=\"white\"/>\n"
        let heading = escape(title ?? String(format: "%04d-%02d", year, month))
        s += "<text x=\"\(width/2)\" y=\"42\" text-anchor=\"middle\" font-family=\"sans-serif\" font-size=\"26\" font-weight=\"600\">\(heading)</text>\n"
        for col in 0..<7 {
            let x = Double(col) * cellW + cellW/2
            s += "<text x=\"\(x)\" y=\"\(headerH-14)\" text-anchor=\"middle\" font-family=\"sans-serif\" font-size=\"14\" fill=\"#444\">\(weekdays[col])</text>\n"
        }
        for row in 0..<6 { for col in 0..<7 {
            let x = Double(col)*cellW, y = headerH + Double(row)*cellH
            s += "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(cellW)\" height=\"\(cellH)\" fill=\"none\" stroke=\"#cbd5e1\"/>\n"
            if row < grid.weeks.count, let date = grid.weeks[row][col] {
                s += "<text x=\"\(x+10)\" y=\"\(y+24)\" font-family=\"sans-serif\" font-size=\"16\" fill=\"#111827\">\(date.day)</text>\n"
            }
        }}
        return s + "</svg>\n"
    }
    private static func escape(_ text: String) -> String { text.replacingOccurrences(of: "&", with: "&amp;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;").replacingOccurrences(of: "\"", with: "&quot;") }
}

/// Produces a one-page, vector PDF month calendar in landscape letter dimensions.
public enum PDFCalendarRenderer {
    public static func render(year: Int, month: Int, weekStart: WeekStart = .sunday) throws -> Data {
        guard let grid = CalendarMonth(year: year, month: month, weekStart: weekStart) else { throw CalendarExportError.invalidMonth }
        let w = 792.0, h = 612.0, left = 36.0, top = 548.0, cellW = 720.0/7, cellH = 78.0
        let weekdays = weekStart == .sunday ? ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"] : ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var c = "BT /F1 22 Tf 0 0 0 rg 1 0 0 1 300 570 Tm (\(year)-\(String(format: "%02d", month))) Tj ET\n"
        c += "0.6 w 0.75 G\n"
        for i in 0...7 { let x = left + Double(i)*cellW; c += "\(x) 80 m \(x) 548 l S\n" }
        for i in 0...6 { let y = 80 + Double(i)*cellH; c += "36 \(y) m 756 \(y) l S\n" }
        for i in 0..<7 { c += "BT /F1 11 Tf 0 0 0 rg 1 0 0 1 \(left+Double(i)*cellW+12) 523 Tm (\(weekdays[i])) Tj ET\n" }
        for r in 0..<grid.weeks.count { for col in 0..<7 { if let date = grid.weeks[r][col] {
            let x = left + Double(col)*cellW + 8, y = top - Double(r)*cellH - 22
            c += "BT /F1 12 Tf 0 0 0 rg 1 0 0 1 \(x) \(y) Tm (\(date.day)) Tj ET\n"
        }}}
        let stream = c.data(using: .ascii)!
        var objects: [Data] = []
        objects.append(Data("<< /Type /Catalog /Pages 2 0 R >>".utf8))
        objects.append(Data("<< /Type /Pages /Kids [3 0 R] /Count 1 >>".utf8))
        objects.append(Data("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 792 612] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>".utf8))
        objects.append(Data("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>".utf8))
        objects.append(Data("<< /Length \(stream.count) >>\nstream\n".utf8) + stream + Data("endstream".utf8))
        var pdf = Data("%PDF-1.4\n%CalendarCraft\n".utf8), offsets = [0]
        for (index, object) in objects.enumerated() {
            offsets.append(pdf.count); pdf.append(Data("\(index+1) 0 obj\n".utf8)); pdf.append(object); pdf.append(Data("\nendobj\n".utf8))
        }
        let xref = pdf.count
        pdf.append(Data("xref\n0 \(objects.count+1)\n0000000000 65535 f \n".utf8))
        for offset in offsets.dropFirst() { pdf.append(Data(String(format: "%010d 00000 n \n", offset).utf8)) }
        pdf.append(Data("trailer\n<< /Size \(objects.count+1) /Root 1 0 R >>\nstartxref\n\(xref)\n%%EOF\n".utf8))
        return pdf
    }
}

Pod::Spec.new do |s|
  s.name             = 'MakeACalendarCraft'
  s.version          = '0.1.0'
  s.summary          = 'Offline Gregorian calendars, business-day math, holidays, SwiftUI, SVG and PDF exports.'
  s.description      = <<-DESC
CalendarCraft is a dependency-free Swift toolkit for Gregorian month and year grids, ISO week dates,
US federal holiday planning, configurable business days, accessible SwiftUI month views, and vector exports.
  DESC
  s.homepage         = 'https://github.com/makeacalendar/make-a-calendar-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ethan' => 'https://make-a-calendar.com/' }
  s.source           = { :git => 'https://github.com/makeacalendar/make-a-calendar-swift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'
  s.swift_version    = '5.9'
  s.source_files     = 'Sources/MakeACalendarCraft/**/*.swift'
  s.frameworks       = 'Foundation', 'SwiftUI'
  s.swift_versions   = ['5.9', '5.10', '6.0']
end

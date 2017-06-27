[Time, Date].map do |klass|
  klass::DATE_FORMATS[:short_date]        = "%e %b, %Y"
  klass::DATE_FORMATS[:short_date_time]   = "%e %b %Y, %H:%M"
end
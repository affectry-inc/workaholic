# nitierlizers/time_formats.rb
# 既に定義されているフォーマット
# default => "2014-10-01 09:00:00 +0900"
# long    => "October 01, 2014 09:00"
# short   => "01 Oct 09:00"
# db      => "2014-10-01 00:00:00"

# カスタムフォーマットを定義
Time::DATE_FORMATS[:h_colon_m] = "%H:%M"
Time::DATE_FORMATS[:slashed_date_h_colon_m] = "%Y/%m/%d %H:%M"
Date::DATE_FORMATS[:m_slash_d] = "%m/%d"
Date::DATE_FORMATS[:y_slash_m] = "%Y/%m"
Date::DATE_FORMATS[:y_slash_m_slash_d] = "%Y/%m/%d"

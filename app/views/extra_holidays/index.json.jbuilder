json.array!(@extra_holidays) do |extra_holiday|
  json.extract! extra_holiday, :id, :title, :description, :is_hourly, :is_comment_required, :is_paid, :is_as_attended
  json.url extra_holiday_url(extra_holiday, format: :json)
end

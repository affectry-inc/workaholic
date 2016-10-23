json.array!(@special_holidays) do |special_holiday|
  json.extract! special_holiday, :id, :title, :description, :special_holiday_ctgr_id, :is_paid, :is_as_attended
  json.url special_holiday_url(special_holiday, format: :json)
end

json.array!(@special_holiday_ctgrs) do |special_holiday_ctgr|
  json.extract! special_holiday_ctgr, :id, :title
  json.url special_holiday_ctgr_url(special_holiday_ctgr, format: :json)
end

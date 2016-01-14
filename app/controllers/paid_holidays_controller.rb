class PaidHolidaysController < ApplicationController
  def index
    @paid_holidays = PaidHoliday.where(user_id: current_user.id).order(:expiration_date)
  end
end

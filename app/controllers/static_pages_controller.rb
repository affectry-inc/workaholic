class StaticPagesController < ApplicationController
  def home
    if logged_in?
      redirect_to new_timecard_path
    else
      redirect_to login_path
    end
  end

  def contact
  end
end

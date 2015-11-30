class TimecardsController < ApplicationController

  def new
    @timecard = Timecard.new
    render 'edit'
  end

  def edit
    @timecard = Timecard.new
  end
end

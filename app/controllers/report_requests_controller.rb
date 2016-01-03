class ReportRequestsController < ApplicationController
  def index
  end

  def edit
    @report_requests = Timecard.new
  end
end

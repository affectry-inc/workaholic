class TimecardsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit]

  def index
    if params[:year] == nil
      b_date = Date.today.beginning_of_month
    else
      b_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
    e_date = b_date.end_of_month

    @b_date = b_date
    @timecards = Timecard.where(biz_date: b_date..e_date)
    @monthly_timecards = Array.new
    (b_date..e_date).each do |date|
      if @timecards.exists?(biz_date: date)
        tc = @timecards.find_by(biz_date: date)
	tc.is_new = false
      else
        tc = Timecard.new
        tc.biz_date = date
        tc.attn_ctgr = 0
        tc.work_start_time = date.to_time
        tc.work_end_time = date.to_time
        tc.rest_start_time = date.to_time
        tc.rest_end_time = date.to_time
        tc.id = 999
	tc.is_new = true
      end
      @monthly_timecards[@monthly_timecards.length] = tc
    end

    @attn_ctgrs = Category.where("ctgr_id = ? and lang_id = ?", 0, 0)
  end

  def new
    biz_date = Date.parse(params[:biz_date])
    @timecard = Timecard.new(biz_date: biz_date, work_start_time: biz_date.to_time,
                             work_end_time: biz_date.to_time,
			     rest_start_time: biz_date.to_time,
			     rest_end_time: biz_date.to_time)
    render 'edit'
  end

  def edit
    @timecard = Timecard.find(params[:id])
  end

  def create
    @timecard = Timecard.new(timecard_params)
    @timecard.user_id = current_user.id
    if @timecard.save
      flash[:success] = "Timecard updated!"
      redirect_to timecards_path
    else
      render 'edit'
    end
  end

  def update
    @timecard = Timecard.find(params[:id])
    if @timecard.update_attributes(timecard_params)
      flash[:success] = "Timecard updated!"
      redirect_to timecards_path
    else
      render 'edit'
    end
  end

  private

    def timecard_params
      params.require(:timecard).permit(:biz_date, :attn_ctgr, :work_start_time, :work_end_time,
				       :rest_start_time, :rest_end_time)
    end

end

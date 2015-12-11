class TimecardsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :create, :update]

  def index
    if params[:year] == nil
      @b_date = Date.today.beginning_of_month
    else
      @b_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
    e_date = @b_date.end_of_month

    if params[:user] == nil
      @user_id = current_user.id
    else
      @user_id = params[:user].to_i
    end

    timecards = Timecard.where(biz_date: @b_date..e_date).where(user_id: @user_id)
    @monthly_timecards = Array.new
    (@b_date..e_date).each do |date|
      if timecards.exists?(biz_date: date)
        tc = timecards.find_by(biz_date: date)
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

  def show
  end

  def new
    biz_date = Date.parse(params[:biz_date])
    @timecard = Timecard.new(biz_date: biz_date, attn_ctgr: 0,
                             work_start_time: biz_date.to_time,
                             work_end_time: biz_date.to_time,
			     rest_start_time: biz_date.to_time,
			     rest_end_time: biz_date.to_time,
			     user_id: params[:user].to_i)

    if editable?(@timecard)
      render 'edit'
    else
      render 'show'
    end
  end

  def edit
    @timecard = Timecard.find(params[:id])

    render 'show' if !editable?(@timecard)
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

    def editable?(timecard)
      if current_user.admin
        true
      elsif timecard.user_id == current_user.id && timecard.biz_date >= Date.today
        true
      else
        approver_of?(timecard.user_id)
      end
    end

    def approver_of?(user_id)
      Approver.where(user_id: user_id).where(approver_user_id: current_user.id).count > 0
    end

end

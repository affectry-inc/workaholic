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
      user_id = current_user.id
    else
      user_id = params[:user].to_i
    end
    @user = User.find(user_id)

    if @user.use_def_times
      def_work_start_time = @user.def_work_start_time || Date.today.to_time
      def_work_end_time = @user.def_work_end_time || Date.today.to_time
      def_rest_start_time = @user.def_rest_start_time || Date.today.to_time
      def_rest_end_time = @user.def_rest_end_time || Date.today.to_time
    else
      def_work_start_time = Date.today.to_time
      def_work_end_time = Date.today.to_time
      def_rest_start_time = Date.today.to_time
      def_rest_end_time = Date.today.to_time
    end
    @biz_days = 0
    @attn_days = 0
    @absc_days = 0
    @work_mins = 0
    attn_ctgrs = Category.where("ctgr_id = ? and lang_id = ?", 0, 0)
    wf_status_ctgr = Category.where("ctgr_id = ? and lang_id = ?", 1, 0)
    timecards = Timecard.where(biz_date: @b_date..e_date).where(user_id: user_id)
    @monthly_timecards = Array.new
    (@b_date..e_date).each do |date|
      if timecards.exists?(biz_date: date)
        tc = timecards.find_by(biz_date: date)
	tc.is_new = false
	if tc.attn_ctgr == 0
	  @attn_days += 1
	  @work_mins += (tc.work_end_time - tc.work_start_time).divmod(60)[0].to_i
	  @work_mins -= (tc.rest_end_time - tc.rest_start_time).divmod(60)[0].to_i
	end
      else
        tc = Timecard.new
        tc.biz_date = date
        tc.attn_ctgr = 0
        tc.work_start_time = sum_date_time(date, def_work_start_time)
        tc.work_end_time = sum_date_time(date, def_work_end_time)
        tc.rest_start_time = sum_date_time(date, def_rest_start_time)
        tc.rest_end_time = sum_date_time(date, def_rest_end_time)
        tc.id = 999
	tc.is_new = true
      end
      if HolidayJapan.check(tc.biz_date)
	tc.holiday_ctgr = 1
	tc.attn_ctgr_disp = HolidayJapan.name(tc.biz_date)
	tc.is_disp_times = false
      elsif tc.biz_date.wday == 0
        tc.holiday_ctgr = 3
	tc.attn_ctgr_disp = "休日"
	tc.is_disp_times = false
      elsif tc.biz_date.wday == 6
        tc.holiday_ctgr = 2
	tc.attn_ctgr_disp = "休日"
	tc.is_disp_times = false
      else
	tc.holiday_ctgr = 0
	tc.attn_ctgr_disp = attn_ctgrs.find_by(val: tc.attn_ctgr).name
	tc.is_disp_times = true
	@biz_days += 1
	@absc_days += 1 if tc.attn_ctgr == 1
      end
      tc.is_disp_times = true if !tc.is_new && tc.attn_ctgr == 0 # Display times if NOT new no matter holiday
      tc.wf_status_ctgr_disp = wf_status_ctgr.find_by(val: tc.wf_status).name

      @monthly_timecards[@monthly_timecards.length] = tc
    end
  end

  def show
  end

  def new
    biz_date = Date.parse(params[:biz_date])
    user = User.find(params[:user])
    if user.use_def_times
      def_work_start_time = sum_date_time(biz_date, user.def_work_start_time)
      def_work_end_time = sum_date_time(biz_date, user.def_work_end_time)
      def_rest_start_time = sum_date_time(biz_date, user.def_rest_start_time)
      def_rest_end_time = sum_date_time(biz_date, user.def_rest_end_time)
    else
      def_work_start_time = biz_date.to_time
      def_work_end_time = biz_date.to_time
      def_rest_start_time = biz_date.to_time
      def_rest_end_time = biz_date.to_time
    end
    @timecard = Timecard.new(biz_date: biz_date, attn_ctgr: 0,
                             work_start_time: def_work_start_time,
                             work_end_time: def_work_end_time,
			     rest_start_time: def_rest_start_time,
			     rest_end_time: def_rest_end_time,
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
    @timecard.modify_times_date
    if params[:submit]
      @timecard.wf_status = 5
    end

    if @timecard.save
      flash[:success] = "Timecard updated!"
      redirect_to timecards_path(user: @timecard.user_id,
                                 year: @timecard.biz_date.year, month: @timecard.biz_date.month)
    else
      render 'edit'
    end
  end

  def update
    @timecard = Timecard.find(params[:id])
    if params[:save]
      @timecard.wf_status = 0
    elsif params[:submit]
      @timecard.wf_status = 5
    elsif params[:approve] && view_context.approver_of?(@timecard.user_id)
      @timecard.wf_status = 9
    end

    if @timecard.update_attributes(timecard_params)
      @timecard.modify_times_date
      @timecard.save
      flash[:success] = "Timecard updated!"
      redirect_to timecards_path(user: @timecard.user_id,
                                 year: @timecard.biz_date.year, month: @timecard.biz_date.month)
    else
      render 'edit'
    end
  end

  def workflow # 2:Sent back 9:Approved
    timecard_id = params[:timecard][:id].to_i
    user_id = params[:timecard][:user].to_i
    wf_status = params[:timecard][:wf].to_i

    if wf_status == 2 || wf_status == 9
      @timecard = Timecard.find(timecard_id)
      @timecard.update_attributes(wf_status: wf_status) if view_context.approver_of?(user_id)
    end

    redirect_to timecards_path(user: @timecard.user_id,
                               year: @timecard.biz_date.year, month: @timecard.biz_date.month)
  end

  private

    def timecard_params
      params.require(:timecard).permit(:biz_date, :attn_ctgr, :work_start_time, :work_end_time,
				       :rest_start_time, :rest_end_time, :user_id)
    end

    def editable?(timecard)
      if current_user.admin
        return true
      end

      if timecard.wf_status == 0 || timecard.wf_status == 2
        return timecard.user_id == current_user.id || view_context.approver_of?(timecard.user_id)
      end

      false
    end

    def sum_date_time(date, time)
      if time
        Time.zone.local(date.year, date.month, date.day, time.hour, time.min, 0)
      else
        Time.zone.local(date.year, date.month, date.day, 0, 0, 0)
      end
    end

end

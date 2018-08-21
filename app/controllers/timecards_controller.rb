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
    @paid_days = 0
    @paid_hours = 0
    @work_mins = 0
    work_mins_a = 0 # 00:00-04:59 0-
    work_mins_b = 0 # 05:00-09:29 300-
    work_mins_c = 0 # 09:30-18:29 570-
    work_mins_d = 0 # 18:30-21:59 1110-
    work_mins_e = 0 # 22:00-23:59 1320-
    @work_mins_holiday = 0
    attn_ctgrs = Category.where("ctgr_id = ? and lang_id = ?", 0, 0)
    wf_status_ctgr = Category.where("ctgr_id = ? and lang_id = ?", 1, 0)
    timecards = Timecard.where(biz_date: @b_date..e_date).where(user_id: user_id)
    @monthly_timecards = Array.new
    (@b_date..e_date).each do |date|
      if timecards.exists?(biz_date: date)
        tc = timecards.find_by(biz_date: date)
        tc.is_new = false
        tc.holiday_ctgr = Timecard.get_holiday_ctgr(tc.biz_date)

        if tc.wf_status >= 5
          if tc.attn_ctgr == 0
            @attn_days += 1
            @paid_hours += tc.paid_holiday_hours
            @work_mins += (tc.work_end_time - tc.work_start_time).div(60)
            @work_mins -= (tc.rest_end_time - tc.rest_start_time).div(60)

            if tc.holiday_ctgr == 0
              work_start_index = tc.work_start_time.hour * 60 + tc.work_start_time.min
              rest_start_index = tc.rest_start_time.hour * 60 + tc.rest_start_time.min
              rest_end_index = tc.rest_end_time.hour * 60 + tc.rest_end_time.min
              work_end_index = tc.work_end_time.hour * 60 + tc.work_end_time.min
              work_blocks = []
              1440.times do |i|
                if i < work_start_index
                  work_blocks.push 0
                elsif i < rest_start_index
                  work_blocks.push 1
                elsif i < rest_end_index
                  work_blocks.push 0
                elsif i < work_end_index
                  work_blocks.push 1
                else
                  work_blocks.push 0
                end
              end
              work_mins_a += work_blocks[0...300].inject(:+) # 00:00-04:59 0-
              work_mins_b += work_blocks[300...570].inject(:+) # 05:00-09:29 300-
              work_mins_c += work_blocks[570...1110].inject(:+) # 09:30-18:29 570-
              work_mins_d += work_blocks[1110...1320].inject(:+) # 18:30-21:59 1110-
              work_mins_e += work_blocks[1320...1440].inject(:+) # 22:00-23:59 1320-
            else
              @work_mins_holiday += (tc.work_end_time - tc.work_start_time).div(60)
              @work_mins_holiday -= (tc.rest_end_time - tc.rest_start_time).div(60)
            end
          elsif tc.attn_ctgr == 2
            @paid_days += 1
          end
        end
      else
        tc = Timecard.new
        tc.biz_date = date
        tc.work_start_time = sum_date_time(date, def_work_start_time)
        tc.work_end_time = sum_date_time(date, def_work_end_time)
        tc.rest_start_time = sum_date_time(date, def_rest_start_time)
        tc.rest_end_time = sum_date_time(date, def_rest_end_time)
        tc.id = 999
        tc.is_new = true
        tc.holiday_ctgr = Timecard.get_holiday_ctgr(tc.biz_date)
        if tc.holiday_ctgr == 0
          tc.attn_ctgr = 0
        else
          tc.attn_ctgr = 9
        end
      end

      if tc.holiday_ctgr == 0
        @biz_days += 1
        @absc_days += 1 if (tc.attn_ctgr == 1) && (tc.wf_status >= 5)
      end

      tc.attn_ctgr_disp = attn_ctgrs.find_by(val: tc.attn_ctgr).name
      tc.wf_status_ctgr_disp = wf_status_ctgr.find_by(val: tc.wf_status).name

      @monthly_timecards[@monthly_timecards.length] = tc
    end
    @work_mins_normal = work_mins_c
    @work_mins_over   = work_mins_b + work_mins_d
    @work_mins_night  = work_mins_a + work_mins_e
    @my_applicants = Approver.where(approver_user_id: current_user.id).where.not(user_id: current_user.id)
    my_group_ids = GroupMember.where(user_id: current_user.id).pluck(:group_id)
    @my_group_members = GroupMember.where(group_id: my_group_ids).where.not(user_id: current_user.id)
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
      remaining_paid_holidays = remaining_paid_holidays(@timecard.biz_date, @timecard.user_id)
      @timecard.remaining_paid_days = remaining_paid_holidays[0].to_i
      @timecard.remaining_paid_hours = remaining_paid_holidays[1].to_i
      render 'edit'
    else
      render 'show'
    end
  end

  def edit
    @timecard = Timecard.find(params[:id])

    remaining_paid_holidays = remaining_paid_holidays(@timecard.biz_date, @timecard.user_id)
    @timecard.remaining_paid_days = remaining_paid_holidays[0].to_i
    @timecard.remaining_paid_hours = remaining_paid_holidays[1].to_i
    if @timecard.attn_ctgr == 2
      @timecard.remaining_paid_days += 1
    elsif @timecard.paid_holiday_hours > 0
      @timecard.remaining_paid_hours += @timecard.paid_holiday_hours
    end

    render 'show' if !editable?(@timecard)
  end

  def create
    @timecard = Timecard.new(timecard_params)
    @timecard.modify_times_date
    if params[:submit]
      @timecard.wf_status = 5
    end

#    if @timecard.attn_ctgr != 0
#      @timecard.paid_holiday_hours = 0
#    end

    if @timecard.save
      if @timecard.attn_ctgr == 2
        use_paid_holiday(@timecard.user_id, @timecard.biz_date, 1, 0)
      elsif @timecard.attn_ctgr == 0 && @timecard.paid_holiday_hours > 0
        use_paid_holiday(@timecard.user_id, @timecard.biz_date, 0, @timecard.paid_holiday_hours)
      end

      flash[:success] = "Timecard updated!"
      redirect_to timecards_path(user: @timecard.user_id,
                                 year: @timecard.biz_date.year, month: @timecard.biz_date.month)
    else
      remaining_paid_holidays = remaining_paid_holidays(@timecard.biz_date, @timecard.user_id)
      @timecard.remaining_paid_days = remaining_paid_holidays[0].to_i
      @timecard.remaining_paid_hours = remaining_paid_holidays[1].to_i
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

      if @timecard.attn_ctgr == 2
        use_paid_holiday(@timecard.user_id, @timecard.biz_date, 1, 0)
      elsif @timecard.attn_ctgr == 0 && @timecard.paid_holiday_hours > 0
        use_paid_holiday(@timecard.user_id, @timecard.biz_date, 0, @timecard.paid_holiday_hours)
      else
        PaidHolidayUsage.delete_all(["user_id = ? and usage_date = ?", @timecard.user_id, @timecard.biz_date])
      end

#      if @timecard.attn_ctgr != 0
#        @timecard.paid_holiday_hours = 0
#      end

      @timecard.save
      flash[:success] = "Timecard updated!"
      redirect_to timecards_path(user: @timecard.user_id,
                                 year: @timecard.biz_date.year, month: @timecard.biz_date.month)
    else
      remaining_paid_holidays = remaining_paid_holidays(@timecard.biz_date, @timecard.user_id)
      @timecard.remaining_paid_days = remaining_paid_holidays[0].to_i
      @timecard.remaining_paid_hours = remaining_paid_holidays[1].to_i
      render 'edit'
    end
  end

  def workflow # 2:Sent back 9:Approved
    timecard_id = params[:timecard][:id].to_i
    user_id = params[:timecard][:user].to_i
    wf_status = params[:timecard][:wf].to_i

    if wf_status == 2 || wf_status == 9
      @timecard = Timecard.find(timecard_id)
      @timecard.update_attribute(:wf_status, wf_status) if view_context.approver_of?(user_id)
    end

    redirect_to timecards_path(user: @timecard.user_id,
                               year: @timecard.biz_date.year, month: @timecard.biz_date.month)
  end

  def apply_all
    user = User.find(params[:id])
    if user.use_def_times
      def_work_start_time = user.def_work_start_time || Date.today.to_time
      def_work_end_time   = user.def_work_end_time || Date.today.to_time
      def_rest_start_time = user.def_rest_start_time || Date.today.to_time
      def_rest_end_time   = user.def_rest_end_time || Date.today.to_time
    end
    target_dates = params[:apply_all_target_dates_form].split
    target_dates.each do |td|
      date = Date.parse(td)
      timecards = Timecard.where(user_id: user.id).where(biz_date: date)
      if timecards.empty?
        tc = Timecard.new
        tc.biz_date = date
        tc.attn_ctgr = 0
        tc.work_start_time = sum_date_time(date, def_work_start_time)
        tc.work_end_time = sum_date_time(date, def_work_end_time)
        tc.rest_start_time = sum_date_time(date, def_rest_start_time)
        tc.rest_end_time = sum_date_time(date, def_rest_end_time)
        tc.user_id = user.id
        tc.wf_status = 5
        tc.save
      else
        timecards.first.update_attribute(:wf_status, 5)
      end
    end
    
    flash[:success] = "#{target_dates.count}件を提出しました。"
    redirect_to timecards_path(user: user.id, year: params[:year], month: params[:month])
  end

  def approve_all
    target_ids = params[:approve_all_target_ids_form].split
    target_ids.each do |ti|
      Timecard.find(ti).update_attribute(:wf_status, 9)
    end
    
    flash[:success] = "#{target_ids.count}件を承認しました。"
    redirect_to timecards_path(user: params[:id], year: params[:year], month: params[:month])
  end

  private

    def timecard_params
      params.require(:timecard).permit(:biz_date, :attn_ctgr, :work_start_time, :work_end_time,
                                       :rest_start_time, :rest_end_time, :user_id, :paid_holiday_hours,
                                       :remaining_paid_days, :remaining_paid_hours)
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

    def remaining_paid_holidays(date, user_id)
      paid_holidays = PaidHoliday.where('beginning_date <= ? and expiration_date >= ? and user_id = ?',
                                  date, date, user_id)
      remainings = Array[0, 0]
      paid_holidays.each do |ph|
        remainings[0] += ph.days
        remainings[1] += ph.hours

        usages = paid_holiday_usage(ph.id, date)
        remainings[0] -= usages[0]
        remainings[1] -= usages[1]
      end
      return remainings
    end

    def paid_holiday_usage(paid_holiday_id, date)
      paid_holiday_usages = PaidHolidayUsage.where('paid_holiday_id = ?', paid_holiday_id)

      usages = Array[0, 0]
      paid_holiday_usages.each do |phu|
        usages[0] += phu.days
        usages[1] += phu.hours
      end
      return usages
    end

    def use_paid_holiday(user_id, date, days, hours)
      PaidHolidayUsage.delete_all(["user_id = ? and usage_date = ?", user_id, date])
      paid_holidays = PaidHoliday.where('beginning_date <= ? and expiration_date >= ? and user_id = ?',
                                  date, date, user_id).order('expiration_date')

      required_days = days
      required_hours = hours
      paid_holidays.each do |ph|
        usages = paid_holiday_usage(ph.id, date)
        remaining_days = ph.days - usages[0]
        remaining_hours = ph.hours - usages[1]
        if required_days > 0 && remaining_days > 0
          if remaining_days >= required_days
            PaidHolidayUsage.create(paid_holiday_id: ph.id, user_id: user_id, usage_date: date,
                                    days: required_days, hours: 0)
            required_days -= required_days
          else
            PaidHolidayUsage.create(paid_holiday_id: ph.id, user_id: user_id, usage_date: date,
                                    days: remaining_days, hours: 0)
            required_days -= remaining_days
          end
        elsif required_hours > 0 && remaining_hours > 0
          if remaining_hours >= required_hours
            PaidHolidayUsage.create(paid_holiday_id: ph.id, user_id: user_id, usage_date: date,
                                    days: 0, hours: required_hours)
            required_hours -= required_hours
          else
            PaidHolidayUsage.create(paid_holiday_id: ph.id, user_id: user_id, usage_date: date,
                                    days: 0, hours: remaining_hours)
            required_hours -= remaining_hours
          end
        end
      end
    end
end

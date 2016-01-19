class ReportsController < ApplicationController
  def index
    @reports = Report.where(receiver_user_id: current_user.id)
  end

  def new
    @report = Report.new
    @target_users = User.where(id: -1)
    @untarget_users = User.where(admin: false)

    render 'edit'
  end

  def edit
    @report = Report.find(params[:id])
    @target_user_ids = @report.report_requests.pluck(:submitter_user_id)
    @target_users = User.where(id: @target_user_ids)
    @untarget_users = User.where.not(id: @target_user_ids).where(admin: false)
  end

  def create
    @report = Report.new(report_params)
    @report.receiver_user_id = current_user.id

    @target_user_ids = params[:report][:target_user_ids].split
    @target_user_ids.each do |u|
      @report.report_requests << ReportRequest.new(submitter_user_id: u.to_i)
    end

    if @report.save
      flash[:success] = "Report updated!"
      redirect_to reports_path
    else
      @target_users = User.where(id: @target_user_ids)
      @untarget_users = User.where.not(id: @target_user_ids).where(admin: false)
      render 'edit'
    end
  end

  def update
    @report = Report.find(params[:id])
    @report.attributes = report_params

    current_target_user_ids = @report.report_requests.pluck(:submitter_user_id)
    @target_user_ids = params[:report][:target_user_ids].split
    del_ids = current_target_user_ids - @target_user_ids
    add_ids = @target_user_ids - current_target_user_ids
    @report.report_requests.each do |rr|
      if del_ids.include?(rr.submitter_user_id) 
	rr.delete
      end
    end
    add_ids.each do |u|
      @report.report_requests << ReportRequest.new(submitter_user_id: u.to_i)
    end

    if @report.save
      flash[:success] = "Report updated!"
      redirect_to reports_path
    else
      @target_users = User.where(id: @target_user_ids)
      @untarget_users = User.where.not(id: @target_user_ids).where(admin: false)
      render 'edit'
    end
  end

  def destroy
    if Report.find(params[:id]).destroy
      flash[:success] = "削除しました。"
    else
      flash[:danger] = "削除に失敗しました。"
    end

    redirect_to reports_path
  end

  def my_reports
    @reports = Report.reports_of(current_user.id)
    @users = User.all
    @report_submission = ReportSubmission.new
  end

  private

    def report_params
      params.require(:report).permit(:report_name, :beginning_date, :due_date)
    end
end

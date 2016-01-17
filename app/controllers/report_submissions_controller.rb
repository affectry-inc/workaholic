class ReportSubmissionsController < ApplicationController

  include FtpAccessor

  def index
    @report = Report.find(params[:r_id])
  end

  def create
    upload_file = params[:report_submission][:upload_file]

    unless upload_file
      flash[:danger] = "ファイルを選択してください。"
      return redirect_to my_reports_path
    end

    filename = upload_file.original_filename
    report_request_id = params[:report_submission][:report_request_id]

    FtpAccessor.put_report(filename, report_request_id, upload_file.path)

    ReportSubmission.where(report_request_id: report_request_id).where(file_name: filename).delete_all
    report_submission = ReportSubmission.new(report_request_id: report_request_id,
                               file_name: filename, submission_time: Time.now)
    if report_submission.save
      flash[:success] = "提出しました。"
    else
      flash[:danger] = "提出に失敗しました。"
    end

    redirect_to my_reports_path
  end

  def destroy
    rs = ReportSubmission.find(params[:id])
    filename = rs.file_name
    report_request_id = rs.report_request_id

    if rs.delete
      FtpAccessor.delete_report(filename, report_request_id)

      flash[:success] = "#{filename} を削除しました。"
    else
      flash[:danger] = "ファイル削除に失敗しました。"
    end
    redirect_to my_reports_path
  end

  def download
    rs = ReportSubmission.find(params[:rs_id])
    filename = rs.file_name
    report_request_id = rs.report_request_id

    filepath_local = FtpAccessor.get_report(filename, report_request_id)

    send_file filepath_local, filename: filename
  end

  def approve
    rr = ReportRequest.find(params[:id])
    rr.update_attribute(:approved, params[:approved])

    render nothing: true
  end
end

class ReportSubmissionsController < ApplicationController
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

    dir = "#{Rails.root}/reports/#{report_request_id}/"
    FileUtils.mkdir(dir) unless File.directory?(dir)
    
    filepath = File.join(dir, filename)
    f        = File.open(filepath, "wb")
    f.write(upload_file.read)
    f.close

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
      dir = "#{Rails.root}/reports/#{report_request_id}/"
      filepath = File.join(dir, filename)
      FileUtils.remove_file(filepath, true)

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

    dir = "#{Rails.root}/reports/#{report_request_id}/"
    filepath = File.join(dir, filename)

    stat = File::stat(filepath)
    send_file filepath
  end

  def approve
    rr = ReportRequest.find(params[:id])
    rr.update_attribute(:approved, params[:approved])

    render nothing: true
  end
end

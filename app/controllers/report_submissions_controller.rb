require 'net/ftp'

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
    filename_store = filename.unpack("H*")[0]
    report_request_id = params[:report_submission][:report_request_id]
    dir = "workaholic/reports/#{report_request_id}/"

    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect(ENV["FTP_HOST"])
    ftp.login(ENV["FTP_USER"], ENV["FTP_PASSWORD"])
    ftp.binary = true
    begin
      ftp.ls dir
    rescue
      ftp.mkdir(dir)
    end
    ftp.put(upload_file.path, File.join(dir, filename_store))
    ftp.quit

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
    report_request_id = rs.report_request_id

    filename = rs.file_name
    filename_store = filename.unpack("H*")[0]

    dir_remote = "workaholic/reports/#{report_request_id}/"
    filepath_remote = File.join(dir_remote, filename_store)
    dir_local = File.join('/tmp', Time.now.strftime('%Y%m%d%H%M%S%N'))
    FileUtils.mkdir(dir_local) unless File.directory?(dir_local)
    filepath_local = File.join(dir_local, filename_store)

    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect(ENV["FTP_HOST"])
    ftp.login(ENV["FTP_USER"], ENV["FTP_PASSWORD"])
    ftp.binary = true
    ftp.get(filepath_remote, filepath_local)
    ftp.quit

    send_file filepath_local, filename: filename
  end

  def approve
    rr = ReportRequest.find(params[:id])
    rr.update_attribute(:approved, params[:approved])

    render nothing: true
  end
end

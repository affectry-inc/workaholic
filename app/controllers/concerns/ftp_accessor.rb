require 'net/ftp'

module FtpAccessor
  # Create following directories under 'FTP_BASE_DIR'.
  #  reports/

  def self.put_report(filename, report_request_id, local_filepath)
    remote_dir = File.join("reports", report_request_id.to_s)
    self.put_private(filename, remote_dir, local_filepath)
  end

  def self.get_report(filename, report_request_id)
    remote_dir = File.join("reports", report_request_id.to_s)
    self.get_private(filename, remote_dir)
  end

  def self.delete_report(filename, report_request_id)
    remote_dir = File.join("reports", report_request_id.to_s)
    self.delete_private(filename, remote_dir)
  end

  def self.put_private(filename, remote_dir, local_filepath)
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(APP_CONFIG['FTP_BASE_DIR'], remote_dir)
    r_filepath = File.join(r_dir, r_filename)

    ftp = self.get_ftp
    begin
      ftp.ls r_dir
    rescue
      ftp.mkdir(r_dir)
    end
    ftp.put(local_filepath, r_filepath)
    ftp.quit
  end

  def self.get_private(filename, remote_dir)
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(APP_CONFIG['FTP_BASE_DIR'], remote_dir)
    r_filepath = File.join(r_dir, r_filename)

    l_dir = File.join('/tmp', Time.now.strftime('%Y%m%d%H%M%S%N'))
    FileUtils.mkdir(l_dir) unless File.directory?(l_dir)
    l_filepath = File.join(l_dir, r_filename)

    ftp = self.get_ftp
    ftp.get(r_filepath, l_filepath)
    ftp.quit

    return l_filepath
  end

  def self.delete_private(filename, remote_dir)
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(APP_CONFIG['FTP_BASE_DIR'], remote_dir)
    r_filepath = File.join(r_dir, r_filename)

    ftp = self.get_ftp
    ftp.delete(r_filepath)
    ftp.quit
  end

  def self.put_public
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(File.join('html', APP_CONFIG['FTP_BASE_DIR']), remote_dir)
    r_filepath = File.join(r_dir, r_filename)

    ftp = self.get_ftp
    begin
      ftp.ls r_dir
    rescue
      ftp.mkdir(r_dir)
    end
    ftp.put(local_filepath, r_filepath)
    ftp.quit
  end

  def self.delete_public
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(File.join('html', APP_CONFIG['FTP_BASE_DIR']), remote_dir)
    r_filepath = File.join(r_dir, r_filename)

    ftp = self.get_ftp
    ftp.delete(r_filepath)
    ftp.quit
  end

  def self.get_public(filename, remote_dir)
    r_filename = filename.unpack("H*")[0]
    r_dir = File.join(File.join(ENV["FTP_HOST"], APP_CONFIG['FTP_BASE_DIR']), remote_dir)
    return File.join(r_dir, r_filename)
  end

  private
    def self.get_ftp
      ftp = Net::FTP.new
      ftp.passive = true
      ftp.connect(ENV["FTP_HOST"])
      ftp.login(ENV["FTP_USER"], ENV["FTP_PASSWORD"])
      ftp.binary = true

      return ftp
    end
end

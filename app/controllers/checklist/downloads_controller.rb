class Checklist::DownloadsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  # GET downloads/
  #
  # Lists a set of downloads for a given list of IDs
  def index
    ids = params[:ids] || ""
    @downloads = Download.where(:id => ids.split(",")).order('updated_at DESC').limit(5)
    @downloads.map! { |v| v.attributes.except("filename", "path") }
    @downloads.each do |v|
      v["updated_at"] = v["updated_at"].strftime("%A, %e %b %Y %H:%M")
    end

    render :text => @downloads.to_json
  end

  # POST downloads/
  def create
    @download = Download.create(params[:download])
    DownloadWorker.perform_async(@download.id, params)

    @download = @download.attributes.except("filename", "path")
    @download["updated_at"] = @download["updated_at"].strftime("%A, %e %b %Y %H:%M")

    render :text => @download.to_json
  end

  # GET downloads/:id/
  def show
    @download = Download.find(params[:id])

    render :text => {status: @download.status}.to_json
  end

  # GET downloads/:id/download
  def download
    @download = Download.find(params[:id])

    if @download.status == Download::COMPLETED
      # Update access time for cache cleaning purposes
      FileUtils.touch(@download.path)

      send_file(@download.path,
        :filename => @download.filename,
        :type => @download.format)
    else
      render :text => {error: "Download not processed"}.to_json
    end
  end

  def download_index
    download_module = {
      "pdf" => Checklist::Pdf,
      "csv" => Checklist::Csv,
      "json" => Checklist::Json
    }

    doc = download_module[params[:format]]::Index.new(params)
    @download_path = doc.generate
    send_file(@download_path,
      :filename => doc.download_name,
      :type => doc.ext)
  end

  def download_history
    download_module = {
      "pdf" => Checklist::Pdf,
      "csv" => Checklist::Csv,
      "json" => Checklist::Json
    }

    doc = download_module[params[:format]]::History.new(params)
    @download_path = doc.generate
    send_file(@download_path,
      :filename => doc.download_name,
      :type => doc.ext)
  end

  private

  def not_found
    render :text => {error: "No downloads available"}.to_json
  end

end

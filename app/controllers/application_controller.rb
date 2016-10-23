class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    #binding.pry
    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      format = params[:format] == :json ? :json : :html
      render file: Rails.root.join('public/404.html'),
        status: 404, layout: false, content_type: 'text/html'
    end
  end

  def require_admin
    render_404 unless logged_in? && current_user.is_admin
  end

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
    redirect_to login_url
    end
  end
end

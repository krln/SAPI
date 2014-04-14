class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end


  def metadata_for_search(search)
    {
      :total => search.total_cnt,
      :page => search.page,
      :per_page => search.per_page
    }
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    admin_root_path
  end
end

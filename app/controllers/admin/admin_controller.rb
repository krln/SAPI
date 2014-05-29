class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referrer || admin_root_path, :alert => case exception.action
      when :destroy
        "You are not authorized to destroy that record"
      else
        exception.message
      end
  end
end

class Admin::TermsController < Admin::AdminController
  inherit_resources
  def index
    @resources = Term.order('code').all
    render :template => 'admin/shared/admin_in_place_editor.html.erb'
  end
end
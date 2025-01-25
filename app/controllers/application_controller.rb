class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Ensure Turbo works correctly with Devise
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end

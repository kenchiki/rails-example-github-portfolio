class Users::RegistrationsController < Devise::RegistrationsController
  before_action :not_found, except: %i[destroy]

  private

  def not_found
    head :not_found
  end
end

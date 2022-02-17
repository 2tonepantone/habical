class Users::SessionsController < Devise::SessionsController
  after_action :remove_notice, only: %i[destroy create]

  private

  def remove_notice
    flash.discard(:notice)
  end
end

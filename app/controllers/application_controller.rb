require 'warwick'

class ApplicationController < ActionController::Base
  include Warwick
  protect_from_forgery

  def edit_mode?
    false
  end

end

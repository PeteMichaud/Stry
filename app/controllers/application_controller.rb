require 'warwick'

class ApplicationController < ActionController::Base
  include Warwick
  protect_from_forgery
  before_filter :authenticate_user!

end

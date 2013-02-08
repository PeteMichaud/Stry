class EditorController < ApplicationController
  before_filter :authenticate_user!

  def edit_mode?
    true
  end

  def index
    redirect_to editor_stories_path
  end

end
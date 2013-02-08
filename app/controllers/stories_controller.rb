class StoriesController < ApplicationController
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.decorate

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    respond_to do |format|
      format.html { render 'editor/stories/show' }
      format.json { render json: @story }
    end
  end

end
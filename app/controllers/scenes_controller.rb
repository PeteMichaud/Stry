class ScenesController < ApplicationController
  # POST /scenes.json
  def create
    @scene = Scene.new(params[:scene])

    respond_to do |format|
      if @scene.story.insert @scene, params[:previous_scene]
        format.html { render 'scenes/show', layout: false, status: 200 }
      else
        format.html { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scenes/1
  def update
    respond_to do |format|
      if @scene.update_attributes(params[:scene])
        if params.has_key? :previous_scene
          @scene.story.insert @scene, params[:previous_scene]
        end
        format.html { head :no_content }
      else
        format.html { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenes/1
  def destroy
    @scene.destroy

    respond_to do |format|
      format.html { head :no_content }
    end
  end

end
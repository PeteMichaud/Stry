class Editor::BlocksController < EditorController
  # POST /blocks.json
  def create
    @block = Block.new(params[:block])

    respond_to do |format|
      if @block.scene.insert @block, params[:previous_block]
        format.html { render 'editor/blocks/show', layout: false, status: 200 }
      else
        format.html { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blocks/1
  def update
    respond_to do |format|
      if @block.update_attributes(params[:block])
        if params.has_key? :previous_block
          @block.scene.insert @block, params[:previous_block]
        end
        format.html { head :no_content }
      else
        format.html { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1
  def destroy
    @block.scene.remove @block

    respond_to do |format|
      format.html { head :no_content }
    end
  end

  def klass_select_markup
    @block = Block.new
    respond_to do |format|
        format.html { render 'editor/blocks/klass_select', layout: false, status: 200 }
    end
  end

end
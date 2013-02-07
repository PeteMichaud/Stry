class AttachmentsController < ApplicationController

  #GET /attachments/new
  def new
  end

  # POST /attachments
  def create
    @attachment = Attachment.new(params[:attachment]).decorate

    respond_to do |format|
      if @attachment.block.insert @attachment, params[:previous_attachment]
        format.html { render 'attachments/show', layout: false, status: 200 }
        format.js
      else
        format.html { render json: @attachment.errors, status: :unprocessable_entity }
        format.js { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  def update
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        if params.has_key? :previous_attachment
          @attachment.block.insert @attachment, params[:previous_attachment]
        end
        format.html { head :no_content }
      else
        format.html { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  def destroy
    @attachment.block.remove @attachment

    respond_to do |format|
      format.html { head :no_content }
    end
  end

end
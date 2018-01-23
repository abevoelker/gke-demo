class CaptionedImagesController < ApplicationController
  def index
    @image = CaptionedImage.new
    @captioned_images = CaptionedImage.all.order("created_at DESC")
  end

  def create
    @image = CaptionedImage.new(create_params)
    if @image.save
      flash[:success] = "Uploaded your captioned image successfully!"
      redirect_to captioned_images_path
    else
      @captioned_images = CaptionedImage.all.order("created_at DESC")
      render :index
    end
  end

  private

  def create_params
    params.require(:captioned_image).permit(:image, :caption)
  end
end

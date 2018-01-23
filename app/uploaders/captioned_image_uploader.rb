require "image_processing/mini_magick"

class CaptionedImageUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions

  process(:store) do |io, context|
    size_512 = resize_to_fill(io.download, 512, 512, gravity: "Center")

    {original: io, square: size_512}
  end
end

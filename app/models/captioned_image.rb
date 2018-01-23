class CaptionedImage < ApplicationRecord
  include CaptionedImageUploader[:image]

  validates :image,
    presence: true
  validates :caption,
    presence: true,
    length: { maximum: 150 }
end

class CreateCaptionedImages < ActiveRecord::Migration[5.1]
  def change
    create_table :captioned_images do |t|
      t.text :caption, null: false, limit: 150
      t.text :image_data, null: false
      t.timestamps null: false
    end
  end
end

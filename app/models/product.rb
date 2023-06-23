class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: { message: 'cannot be blank.' }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:    /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :description, allow_blank: true, length: { minimum: 10 }
end

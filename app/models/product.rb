class Product < ApplicationRecord
  include ActiveRecord::Serialization

  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: { message: 'cannot be blank.' }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:    /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :description, allow_blank: true, length: { minimum: 10 }

  private

  def ensure_not_referenced_by_any_line_item
    return if line_items.empty?

    errors.add :base, 'Line Items present'
    throw :abort
  end
end

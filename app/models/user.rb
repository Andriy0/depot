class User < ApplicationRecord
  has_secure_password

  attr_accessor :old_password, :force_update

  validates :name, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, unless: :force_update, if: :password

  with_options on: :update, unless: :force_update do
    validates :old_password, presence: true, if: :password
    validate :old_password_must_be_correct
  end

  after_destroy :ensure_an_admin_remains

  class Error < StandardError; end

  private

  def ensure_an_admin_remains
    return unless User.count.zero?

    raise Error.new('Cannot delete last user')
  end

  def old_password_must_be_correct
    # binding.pry
    errors.add :old_password, 'must be correct' if old_password.present? && !authenticate(old_password)
  end
end

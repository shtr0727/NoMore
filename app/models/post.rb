class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :streak, optional: true
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
end

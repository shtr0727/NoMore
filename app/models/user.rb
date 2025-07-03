class User < ApplicationRecord
  has_many :posts
  has_many :favorites
  has_many :comments
end

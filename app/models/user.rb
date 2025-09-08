class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one_attached :profile_image

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーのフォローを解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy if following?(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしている場合はtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 投稿をいいねする
  def favorite(post)
    favorites.create(post: post) unless favorited?(post)
  end

  # 投稿のいいねを解除する
  def unfavorite(post)
    favorites.find_by(post: post)&.destroy
  end

  # 投稿をいいねしているかチェック
  def favorited?(post)
    favorites.exists?(post: post)
  end
end

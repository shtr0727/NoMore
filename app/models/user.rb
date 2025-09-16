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
  has_many :streaks, dependent: :destroy
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

  # ユーザーが現在獲得しているバッジ（動的計算）
  def earned_badges
    badge_ids = posts.map(&:current_badges).flatten.map(&:id).uniq
    Badge.where(id: badge_ids).order(:required_days)
  end
  
  # 継続日数バッジのみ
  def streak_badges
    earned_badges.where(badge_type: 'streak')
  end
  
  # 現在最も高いバッジ
  def highest_badge
    earned_badges.order(:required_days).last
  end
  
  # 最高継続日数（ステータスに関係なく）
  def max_streak_count
    posts.includes(:streak)
         .map { |post| post.streak_count }
         .max || 0
  end
  
  # 現在継続中の習慣数
  def active_streaks_count
    posts.includes(:streak)
         .select { |post| post.streak_active? }
         .count
  end

end

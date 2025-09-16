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

  # プロフィール画像のバリデーション
  validate :profile_image_validation

  def profile_image_validation
    return unless profile_image.attached?

    # ファイルタイプの検証
    acceptable_types = ["image/jpeg", "image/png", "image/gif"]
    unless acceptable_types.include?(profile_image.blob.content_type)
      errors.add(:profile_image, "JPEG、PNG、GIFファイルのみアップロード可能です。")
    end

    # ファイルサイズの検証
    if profile_image.blob.byte_size > 5.megabytes
      errors.add(:profile_image, "ファイルサイズは5MB以下にしてください。")
    end
  end

  # プロフィール画像の取得（デフォルト画像を含む）
  def display_image
    if profile_image.attached?
      profile_image
    else
      # デフォルト画像のパスを返す（後でCSSで実装）
      nil
    end
  end

  # プロフィール画像が添付されているかチェック
  def has_profile_image?
    profile_image.attached?
  end

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

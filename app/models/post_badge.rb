class PostBadge < ApplicationRecord
  belongs_to :post
  belongs_to :badge
  
  validates :post_id, uniqueness: { scope: :badge_id, message: "は既にこのバッジを獲得しています" }
  
  # バッジ獲得日時を記録（created_atを使用）
  def earned_at
    created_at
  end
  
  # 継続日数バッジかどうか
  def streak_badge?
    badge.streak_badge?
  end
end

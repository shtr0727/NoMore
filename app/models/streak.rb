class Streak < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # ストリークの状態定数
  STATUS_ACTIVE = '継続中'.freeze
  STATUS_BROKEN = 'うっかり'.freeze
  
  validates :status, inclusion: { in: [STATUS_ACTIVE, STATUS_BROKEN] }
  
  # 現在の継続日数を計算（投稿ごと）
  def current_count
    return 0 if status == STATUS_BROKEN
    
    # 投稿作成日から今日まで、その習慣を継続した日数
    # dateは投稿の記録日（recorded_on）が設定されている
    days_since_start = (Date.current - date).to_i + 1
    [days_since_start, 0].max
  end
  
  # ストリークをリセット（うっかり状態にする）
  def reset!
    # 投稿のrecorded_onを基準日として使用
    reset_date = post&.recorded_on || Date.current
    update!(status: STATUS_BROKEN, date: reset_date)
  end
  
  # ストリークを継続（継続中状態にする）
  def continue!
    # 元の投稿日に戻して継続状態にする
    original_date = post&.recorded_on || date
    update!(status: STATUS_ACTIVE, date: original_date)
  end
end

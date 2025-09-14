class Streak < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # ストリークの状態定数
  STATUS_ACTIVE = '継続中'.freeze
  STATUS_BROKEN = 'うっかり'.freeze
  
  validates :status, inclusion: { in: [STATUS_ACTIVE, STATUS_BROKEN] }
  
  # 現在の継続日数を計算（投稿ごと）
  def current_count
    # 投稿の記録日から今日まで、その習慣を継続した日数（当日は含めない）
    start_date = date || (post&.recorded_on) || Date.current
    today = Date.current
    
    # 未来の日付の場合は0を返す
    return 0 if start_date > today
    
    days_since_start = (today - start_date).to_i
    [days_since_start, 0].max
  end
  
  # ストリークをリセット（うっかり状態にする）
  def reset!
    # 投稿のrecorded_onを基準日として使用
    reset_date = post&.recorded_on || Date.current
    update!(status: STATUS_BROKEN, date: reset_date)
  end
  
  
  # 投稿の日付変更に合わせてストリークの基準日を更新
  def update_date_from_post!
    return unless post&.recorded_on
    
    Rails.logger.info "DEBUG: Updating streak date from #{date} to #{post.recorded_on}"
    # recorded_onが変更された場合は、継続状態を維持したまま基準日を更新
    update!(date: post.recorded_on)
    Rails.logger.info "DEBUG: Streak date updated to #{reload.date}"
  end
end

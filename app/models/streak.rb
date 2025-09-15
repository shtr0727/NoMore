class Streak < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # recorded_onから継続日数を動的に計算
  def current_count
    return 0 unless post&.recorded_on
    
    start_date = post.recorded_on
    today = Date.current
    
    # 未来の日付の場合は0を返す
    return 0 if start_date > today
    
    # 開始日から今日までの日数
    days_since_start = (today - start_date).to_i
    [days_since_start, 0].max
  end
  
  # 継続状態を動的に判定
  def active?
    return false unless post&.recorded_on
    
    # 投稿日が今日以前であれば継続中とみなす
    post.recorded_on <= Date.current
  end
  
  # うっかり状態かどうかを判定（現在は使用しない - 将来的に日付の連続性チェックに使用可能）
  def broken?
    !active?
  end
  
  # ステータスを文字列で取得（ビュー表示用）
  def status
    if post&.recorded_on && post.recorded_on > Date.current
      'future'
    elsif active?
      '継続中'
    else
      'うっかり'
    end
  end
  
  # 投稿の日付変更に合わせてストリークの基準日を更新
  def update_date_from_post!
    return unless post&.recorded_on
    
    Rails.logger.info "DEBUG: Updating streak date from #{date} to #{post.recorded_on}"
    # recorded_onの変更に合わせて基準日を更新
    update!(date: post.recorded_on)
    Rails.logger.info "DEBUG: Streak date updated to #{reload.date}"
  end
end

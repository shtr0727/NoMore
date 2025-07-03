class PostBadge < ApplicationRecord
  belongs_to :post
  belongs_to :badge
end

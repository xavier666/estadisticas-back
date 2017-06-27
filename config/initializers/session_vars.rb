CURRENT_SEASON    = Setting.find_by_key("current_season").try(:value) || "2016"
CURRENT_ROUND     = Setting.find_by_key("current_round").try(:value)  || "1"
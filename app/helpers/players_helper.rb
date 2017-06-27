module PlayersHelper

  def player_image player, folder = "original"
    if player.image
      logical_path = 'players/'+folder+'/'+player.image.to_s
      if asset_available? logical_path
        image_tag(asset_path(logical_path), alt: player.full_name).html_safe if player.image
      else
        image_tag(asset_path('players/'+folder+'/default.jpg'), alt: player.full_name).html_safe
      end
    else 
      image_tag(asset_path('players/'+folder+'/default.jpg'), alt: player.full_name).html_safe
    end
  end

  def player_price price
    number_with_delimiter(price, delimiter: ".")
  end
end
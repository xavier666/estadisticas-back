task :update_stats_to_f => :environment do
	#FIELDS = %w( pt a br bp c m fp fr mas_menos v sm )
  	#FIELDS_DEFAULT = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0.00" ]  


	Statistic.all.each do |s|
		(1..34).each do |week|
			s.send("week_#{week}")["pt"] = s.send("week_#{week}")["pt"].to_f
			s.send("week_#{week}")["a"] = s.send("week_#{week}")["a"].to_f
			s.send("week_#{week}")["br"] = s.send("week_#{week}")["br"].to_f
			s.send("week_#{week}")["bp"] = s.send("week_#{week}")["bp"].to_f
			s.send("week_#{week}")["c"] = s.send("week_#{week}")["c"].to_f
			s.send("week_#{week}")["m"] = s.send("week_#{week}")["m"].to_f
			s.send("week_#{week}")["fp"] = s.send("week_#{week}")["fp"].to_f
			s.send("week_#{week}")["fr"] = s.send("week_#{week}")["fr"].to_f
			s.send("week_#{week}")["mas_menos"] = s.send("week_#{week}")["mas_menos"].to_f
			s.send("week_#{week}")["v"] = s.send("week_#{week}")["v"].to_f
			s.send("week_#{week}")["sm"] = s.send("week_#{week}")["sm"].to_f
			puts s.send("week_#{week}")["pt"]
			s.save!
		end
	end
end
require "mechanize"
require "nokogiri"
#ruby2.1.1


#you can fill the url array with all the hashtags you want info on
<<<<<<< HEAD
url = ["surf", "surfing", "surfboard", "surfer", "hangloose", "chill", "beach", "surfsup", "aloha", "travel", "extreme", "redbull", "billabong", "roxy", "oakley", "quiksilver", "ripcurl", "australia", "hawaii", "california", "miami", "sand", "sea", "ocean", "reef", "wave", "waves", "wetsuit", "hurley", "gopro", "motheranddaughter", "california", "photoshoot", "photos", "thegettycenter", "losangeles", "california", "California", "DriverlessCars", "SmartGlassFans", "ReviewTheBest", "hustleseasoncollection", "hustleseasonthebrand", "only1season", "designer", "streetwear", "style", "clothingline", "newyork", "california", "florida", "miami", "atlanta", "toyko", "dubai", "france", "paris", "huntingtonbeach", "losangeles", "pool", "sun", "surfcity", "california", "relax", "beachday", "beautiful", "beachlife", "overcast", "flower", "weeds", "summerhasarrived", "ocean", "norcalbeach", "california", "californiadream", "californialove", "mylife", "livehappiness", "breakfast", "food", "foodporn", "hillcrest", "sandiego", "california", "mimosa", "coffee", "tbt", "SpringBreak", "LegDay", "ClearLake", "California", "Stoner", "Fitness", "money", "racks", "takeiteasy", "lovesvoice", "tbt", "tbt", "ocean", "monterey", "california", "bestfriend", "lover", "bitch", "comeback", "loveyou", "hoe", "perfect", "view", "kisses", "smiles", "HarleyDavidson", "RoadGlideUltra", "Harley", "touring", "roadglide", "riversideharley", "riverside", "california", "kingline", "kinglinebullies", "kingline_bullies", "kuwaitbullies", "disney", "california", "californiaadventure", "paradisepier"]
fp = File.new("Autobot9.txt", "w")
=======
time = Time.new
url = ["karmaloop", "crooksandcastles", "hat", "snapback", "croc", "style", "swag", "wdywt", "kotd", "diamondsupply", "diamondlife", "blackscale", "obey", "lrg", "rocksmith", "pinkdolphin", "asos", "urbanoutfitters", "jordan", "crooks", "college", "ootd", "makeup", "huf", "high", "skateboarding", "strapback", "trukfit", "team", "pro", "surfing", "town", "city", "carver", "enjoy", "style", "respect", "canarias", "canaryislands", "enjoy", "longboarding", "skateboarding", "spot", "secret", "oldchool", "skate", "skatelife", "skateboarding", "skate", "skateboard", "skateboarding", "deck", "instant", "skateboarding", "skating", "skate", "fuckafilter", "triplex", "gnarly", "fun", "florida", "hyped", "birthday", "bday", "sk8", "skateboarding", "skating", "nothing", "forever", "skateboarding", "skating", "skater", "hashgram", "instaskater", "sk8", "sk8er", "sk8ing", "sk8ordie", "photooftheday", "board", "longboard", "longboarding", "riding", "kickflip", "ollie", "instagood", "wheels", "skatephotoaday", "skateanddestroy", "skateeverydamnday", "skatespot", "skaterguy", "skatergirl", "skatepark", "skateboard", "throwback", "skateboarding", "skateboarding", "skatepark", "skateordie", "playground", "tbt", "frontsideair", "skateboarding", "livermore", "skatepark", "chapter", "chapterharajuku", "chapterworld", "nike", "nikesb", "nikeskateboarding", "skateboarding", "lunar", "gato", "lunargato", "wc", "fifaworldcup", "france", "football", "soccer", "sneaker", "footwear", "kicksoftheday", "kicksfortoday", "todayskicks", "sneakerheads", "sneakerchick", "kickstagram", "kickflipping", "stairs", "hingham", "skatepark", "skateboarding", "skateboarding"]
fp = File.new("Auto#{time.month}#{time.day}#{time.year}#{time.hour}#{time.min}.txt", "w")
>>>>>>> takeputsout

agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }

url.each do |i|
	
	#loads each page using the array "url"
	
	html = agent.get("http://ink361.com/app/tag/#{i}").body
	html_doc = Nokogiri::HTML(html)

	#gets the hashtag name and removes formating 
	
	list = html_doc.xpath("//*[contains(concat(' ', normalize-space(@class), ' '), ' slightLeft ')]")
	liststring = list.to_s
	listscan = liststring.scan(/#([a-zA-Z]\w*)/)
	listtitle = listscan[0].to_s.delete!"[]"
	fp.write(listtitle + "\t")
	
	#gets the Media Count for each hashtag, coverts from ex. 1.6M => 1600000 (int).
	#works for 1.6K, 1.6M, 1.6B (Thousand,Million,Billion)
	
	list = html_doc.xpath("//*[(@id = 'mediaCount')]")
	liststring = list.to_s
	listscan = liststring.scan(/>(.+)</)
	listtitle = listscan[0].to_s.delete!("[]")
	if listtitle.include?("K") == true
		realnumber = listtitle.delete("K")
		realnumber = realnumber.delete!('""').to_f
		realnumber = realnumber * 1000.0
		realnumber = realnumber.to_i
		fp.write(realnumber)
		fp.write("\t")
	elsif listtitle.include?("M") == true
		realnumber = listtitle.delete("M")
		realnumber = realnumber.delete!('""').to_f
		realnumber = realnumber * 1000000.0
		realnumber = realnumber.to_i
		fp.write(realnumber)
		fp.write("\t")
	elsif listtitle.include?("B") == true
		realnumber = listtitle.delete("B")
		realnumber = realnumber.delete!('""').to_f
		realnumber = realnumber * 1000000000.0
		realnumber = realnumber.to_i
		fp.write(realnumber)
		fp.write("\t")
	else
		realnumber = listtitle.delete!('""').to_i
		fp.write(realnumber)
		fp.write("\t")
	end

	#gets all hastags found (related hastags) on that hastag page. All are in "" with , seperating
	
	list = html_doc.xpath("//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'medcaption', ' ' ))]")
	liststring = list.to_s
	regex = /#([a-zA-Z]\w+)/
	finallist = []
	liststring.scan(/#([a-zA-Z]\w+)/) do
		match_data = Regexp.last_match.to_s
		matchy_data = match_data.scan(/#([a-zA-Z]\w*)/)
		finallist.push(matchy_data)
	end
	finalnobrack = finallist.to_s.delete!"[]"
	fp.write(finalnobrack)

	# creates a new line in the txt file (mac) which creates a new row.
	# the program  then waits a random amount of seconds before looping the next string in the array.
	fp.write("\n")
	sleeper = Random.rand(2...5)
	sleep(sleeper)
	puts "#{i} Scraped Succesfully"
end




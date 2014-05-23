require "mechanize"
require "nokogiri"
#ruby2.1.1


#you can fill the url array with all the hashtags you want info on

url = ["motivational", "wisdom", "success", "truth", "life", "success", "health", "wealth", "love", "business", "motivational", "inspirational", "sit", "relax", "breathe", "quote", "motivational", "inspirational", "energise", "rest", "coffee", "loveit", "health", "fitness", "gym", "motivation", "happy", "worldchamp", "abudhabi", "nyc", "longisland", "farmingdale", "trainer", "jiujitsu", "socabjj", "motivational", "learn", "MARTIALARTS", "motivation", "socabjjacademy", "loveit", "best", "brazil", "brooklyn", "amazing", "family", "life", "summer", "fitfam", "win", "frankthetankfitness", "newy", "health", "fitness", "gym", "motivation", "happy", "worldchamp", "abudhabi", "nyc", "longisland", "farmingdale", "trainer", "jiujitsu", "socabjj", "motivational", "learn", "MARTIALARTS", "motivation", "socabjjacademy", "loveit", "best", "brazil", "brooklyn", "motivate", "motivation", "motivational", "inspire", "inspirational", "inspiration", "staystrong", "believe", "nevergiveup", "faith", "hope", "love", "perseverance", "quotes", "neveralone", "Iloveyou", "Christian", "God", "Jesus", "beautiful", "positive", "YOU", "cute", "peace", "heart", "kittens", "health", "fitness", "gym", "motivation", "happy", "worldchamp", "abudhabi", "nyc", "longisland", "farmingdale", "trainer", "jiujitsu", "socabjj", "motivational", "learn", "MARTIALARTS", "motivation", "socabjjacademy", "loveit", "best", "brazil", "brooklyn", "amazing", "family", "life", "summer", "fitfam", "win", "frankthetankfitness", "newy", "life", "strong", "motivational", "muscle", "amateurbodybuilder", "dedication", "beastmodeon", "norules", "workout", "training", "fit4life", "lifestyle", "power", "healt", "results", "motivation", "bestrong", "fitness", "folowyourdreams", "latino", "focus", "traindirty", "theman", "feelfree", "disciplina", "motivaciongym", "dearhardwork", "de", "health", "fitness", "gym", "motivation", "happy", "worldchamp", "abudhabi", "nyc", "longisland", "farmingdale", "trainer", "jiujitsu", "socabjj", "motivational", "learn", "MARTIALARTS", "motivation", "socabjjacademy", "loveit", "best", "brazil", "brooklyn", "amazing", "family", "lif", "bodybuilding", "gymtime", "fitness", "fit", "healthy", "lift", "motivational", "whey", "protein", "gym", "simple", "truth", "life", "dreams", "goals", "limitless", "doyou", "happiness", "fitquotes", "instaquotes", "quotes", "achieve", "strength", "positive", "healthy", "fit", "fitlife", "health", "fitness", "gym", "motivation", "happy", "balance", "yinyang", "nyc", "longisland", "strongisland", "trainer", "jiujitsu", "socabjj", "motivational", "fitspo", "powerful", "MARTIALARTS", "love", "thebasementbattles", "cleaneating", "active", "healthychoices", "determination", "body", "lifestyle", "frank", "real", "friendship", "house", "nap", "powernep", "sleep", "sleeping", "wisdom", "motivational", "motivated", "motivation", "inspiration", "inspire", "inspirational", "postivity", "positive", "quote", "quotes", "poetry", "health", "fitness", "gym", "motivation", "happy", "worldchamp", "abudhabi", "nyc", "longisland", "farmingdale", "trainer", "jiujitsu", "socabjj", "motivational", "learn", "MARTIALARTS", "motivation", "socabjjacademy", "loveit", "best", "brazil", "brooklyn", "amazing", "fam", "humanity", "qotd", "animals", "chimpanzee", "gorillas", "monkeys", "love", "tenderness", "care", "peace", "kiss", "relationships", "motivational", "motivation", "alivepulse", "alivegroup", "bible", "motivational", "christian", "God"]
fp = File.new("Autobot15.txt", "w")

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




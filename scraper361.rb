require "mechanize"
require "nokogiri"
#ruby2.1.1


#you can fill the url array with all the hashtags you want info on
url = ["surf", "surfing", "surfboard", "surfer", "hangloose", "chill", "beach", "surfsup", "aloha", "travel", "extreme", "redbull", "billabong", "roxy", "oakley", "quiksilver", "ripcurl", "australia", "hawaii", "california", "miami", "sand", "sea", "ocean", "reef", "wave", "waves", "wetsuit", "hurley", "gopro", "motheranddaughter", "california", "photoshoot", "photos", "thegettycenter", "losangeles", "california", "California", "DriverlessCars", "SmartGlassFans", "ReviewTheBest", "hustleseasoncollection", "hustleseasonthebrand", "only1season", "designer", "streetwear", "style", "clothingline", "newyork", "california", "florida", "miami", "atlanta", "toyko", "dubai", "france", "paris", "huntingtonbeach", "losangeles", "pool", "sun", "surfcity", "california", "relax", "beachday", "beautiful", "beachlife", "overcast", "flower", "weeds", "summerhasarrived", "ocean", "norcalbeach", "california", "californiadream", "californialove", "mylife", "livehappiness", "breakfast", "food", "foodporn", "hillcrest", "sandiego", "california", "mimosa", "coffee", "tbt", "SpringBreak", "LegDay", "ClearLake", "California", "Stoner", "Fitness", "money", "racks", "takeiteasy", "lovesvoice", "tbt", "tbt", "ocean", "monterey", "california", "bestfriend", "lover", "bitch", "comeback", "loveyou", "hoe", "perfect", "view", "kisses", "smiles", "HarleyDavidson", "RoadGlideUltra", "Harley", "touring", "roadglide", "riversideharley", "riverside", "california", "kingline", "kinglinebullies", "kingline_bullies", "kuwaitbullies", "disney", "california", "californiaadventure", "paradisepier"]
fp = File.new("Autobot9.txt", "w")

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
	puts "list: #{list}"
	liststring = list.to_s
	puts "liststring: #{liststring}"
	listscan = liststring.scan(/>(.+)</)
	puts "listscan: #{listscan}"
	listtitle = listscan[0].to_s.delete!("[]")
	puts "listtitle: #{listtitle}"
	if listtitle.include?("K") == true
		realnumber = listtitle.delete("K")
		puts "no K: #{realnumber}"
		realnumber = realnumber.delete!('""').to_f
		puts "No hash: #{realnumber}"
		realnumber = realnumber * 1000.0
		puts "Bigger float: #{realnumber}"
		realnumber = realnumber.to_i
		puts "Bigger Int: #{realnumber}"
		fp.write(realnumber)
		fp.write("\t")
	elsif listtitle.include?("M") == true
		realnumber = listtitle.delete("M")
		puts "no K: #{realnumber}"
		realnumber = realnumber.delete!('""').to_f
		puts "No hash: #{realnumber}"
		realnumber = realnumber * 1000000.0
		puts "Bigger float: #{realnumber}"
		realnumber = realnumber.to_i
		puts "Bigger Int: #{realnumber}"
		fp.write(realnumber)
		fp.write("\t")
	elsif listtitle.include?("B") == true
		realnumber = listtitle.delete("B")
		puts "no K: #{realnumber}"
		realnumber = realnumber.delete!('""').to_f
		puts "No hash: #{realnumber}"
		realnumber = realnumber * 1000000000.0
		puts "Bigger float: #{realnumber}"
		realnumber = realnumber.to_i
		puts "Bigger Int: #{realnumber}"
		fp.write(realnumber)
		fp.write("\t")
	else
		realnumber = listtitle.delete!('""').to_i
		fp.write(realnumber)
		fp.write("\t")
	end

	#gets all hastags found (related hastags) on that hastag page. All are in "" with , seperating
	
	list = html_doc.xpath("//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'medcaption', ' ' ))]")
	puts list
	liststring = list.to_s
	puts liststring
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
	print finallist
	fp.write("\n")
	sleeper = Random.rand(2...5)
	sleep(sleeper)
end




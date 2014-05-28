require "mechanize"
require "nokogiri"
#ruby2.1.1


#you can fill the url array with all the hashtags you want info on
puts ""
puts ""

time = Time.new
url = ["analog", "analognikon", "picoftheday", "fotooftheday", "follow4follow", "follower", "bw", "myshoot", "not4ordinary", "world", "black", "comments", "landscape", "explore", "instanesia", "instagramer", "oilpaint", "oiloncavas", "fingerpainting", "fineart", "not4ordinary", "BESTDM", "modernart", "abstractart", "jazz", "god", "life", "death", "happy", "love", "outsiderart", "oilpaint", "oiloncanvasboard", "modernart", "outsiderart", "fashion", "figurativepainting", "fingerpainting", "fineart", "abstractart", "authenticliving", "BESTDM", "not4ordinary", "writersofinstagram", "poem", "poetry", "popart", "dada", "dadistart", "undergroundcomicbookart", "allium", "garden", "nature", "naturelovers", "instagood", "picoftheday", "pictureoftheday", "webstagram", "photowall", "photolocker", "edorsson_photo_awards", "unsung_masters", "lovelettertoshrewsbury", "macro", "icatching", "great_image", "capture_today", "not4ordinary", "pixel", "minimalism", "electronicsocialart", "NES", "retro", "abstractors_anonymous", "artist", "art", "minimal", "surrealart", "digitalart", "surreal", "pastel", "abstract", "creative", "nintendo", "minimalobsession", "minimalism42", "surreal42", "future", "pixels", "not4ordinary", "artistic", "glitch", "surreal42fb", "my_daily_capture", "nature_isa", "not4ordinary", "naturesbeauty", "natureskingdom", "bpa_nature", "bpa_membersonly", "vibrant_globe", "capture_today", "jn_colourwheel", "gpwoot", "frameable", "fpog", "surreal42", "soul_curry", "surreal42fb", "splendid_shotz", "at_diff", "arteemfoco", "award_gallery", "arte_of_nature", "pf_arts", "photowall", "Art", "abstract", "colourful", "spiritual", "nature", "bestoftheday", "instafollow", "instegram", "beautiful", "meditation", "serene", "nature", "creative", "artstagram", "TagsForLikes", "pictureoftheday", "not4ordinary", "instagood", "instatalent", "instigram", "instegram", "instraart", "instafollow", "instata", "RogueEditSociety", "instaart", "digitalart", "ig_artgallery", "iphonesia", "instagramhub", "bestoftheday", "vscocam", "iphonography", "igdaily", "webstagram", "modernart", "artsetfree", "ueditfever", "statigram", "europe", "asia", "vsco", "abstract", "fineart", "uk", "france", "germany", "digitalart", "surreal42fb", "not4ordinary", "surreal42", "RogueEditSociety", "instaart", "digitalart", "ig_artgallery", "iphonesia", "instagramhub", "bestoftheday", "vscocam", "iphonography", "igdaily", "webstagram", "modernart", "artsetfree", "ueditfever", "statigram", "europe", "asia", "vsco", "abstract", "fineart", "uk", "france", "germany", "digitalart", "surreal42fb", "not4ordinary", "surreal42", "artistz_united"]
fp = File.new("Auto#{time.month}#{time.day}#{time.year}#{time.hour}#{time.min}.txt", "w")

puts "Beginning scraping..."
puts ""

agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }

url.each_with_index do |i, ind|
	
	indexi = ind + 1
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
	puts "#{i.upcase} scraped succesfully, #{indexi} of #{url.count}"
end
puts "--COMPLETE--"
puts ""




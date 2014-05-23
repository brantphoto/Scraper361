require "mechanize"
require "nokogiri"
#ruby2.1.1


#you can fill the url array with all the hashtags you want info on
puts ""
puts ""

time = Time.new
url = ["decim8", "thou_shall_decim8", "the_abstract_collective", "abstract", "abstractobsession", "abstractors_anonymous", "ma_creative", "surreal42", "abstracteyesat42", "jj_abstract", "rsa_graphics", "sbe_graphics", "pf_arts", "exk_arts", "ampt_surreal", "lightedlight", "u_b_e", "destroy2cre8", "mobileartistry", "ig_artis", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "Africa", "ig_photoflair_graphics", "contemporaryart", "the_abstract_collective", "abstractors_anonymous", "abstracteyesat42", "applifam23may", "abstracteyesat42", "abstractors_anonymous", "artistz_united", "photo_rush", "photo_best11", "shutterbug_abstract", "not4ordinary", "the_abstract_collective", "gpwoot", "hubcreative", "you_nique_edits", "wiggteam", "arteemfoco", "arte_of_nature", "at_diff", "abstracteyesat42", "abstractors_anonymous", "cs_abstract", "shutterbug_abstract", "sbe_graphics", "pf_graphics", "hubcreative", "arte_of_nature", "artistz_united", "arteemfoco", "at_diff", "gpwoot", "you_nique_edits", "not4ordinary", "the_abstract_collective", "surreal42", "surreal42fb", "tos_surrealfantasy", "friendsinshadowandlight", "applifam23may", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork", "artistz_united", "whostagram", "e_wiz_mems", "abstractors_anonymous", "cs_ag", "jj_abstract", "pf_graphics", "design42", "abstracteyesat42", "sbe_graphics", "electronicsocialart", "cs_abstract", "cf_graphics", "not4ordinary", "gi_artwork"]
fp = File.new("Auto#{time.month}#{time.day}#{time.year}#{time.hour}#{time.min}.txt", "w")

puts "Scraping to file #{fp} begin..."
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




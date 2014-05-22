require "mechanize"
require "nokogiri"
#ruby2.1.1

url = ["inspiration", "motivational", "helloworld"]
fp = File.new("Autobot7.txt", "w")

agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }

url.each do |i|
	html = agent.get("http://ink361.com/app/tag/#{i}").body
	html_doc = Nokogiri::HTML(html)


	list = html_doc.xpath("//*[contains(concat(' ', normalize-space(@class), ' '), ' slightLeft ')]")
	liststring = list.to_s
	listscan = liststring.scan(/#([a-zA-Z]\w*)/)
	listtitle = listscan[0].to_s.delete!"[]"
	fp.write(listtitle + "\t")

	list = html_doc.xpath("//*[(@id = 'mediaCount')]")
	liststring = list.to_s
	listscan = liststring.scan(/>(.+)</)
	listtitle = listscan[0].to_s.delete!"[]"



	fp.write(listtitle + "\t")

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

	print finallist
	fp.write("\n")
	sleeper = Random.rand(2...5)
	sleep(sleeper)
end




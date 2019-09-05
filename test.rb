require 'open-uri'
require 'csv'

PROXY = URI.parse("http://127.0.0.1:8118")
URL = 'https://export.yandex.ru/last/last20x.xml'

1000.times.each do
	print '.'
	open(URL, proxy: PROXY) do |fh|
		xml = fh.read

		results = xml.scan(%r(<item found="(\d+)">(.*?)</item>)) 

		CSV.open('./yandex/last20.csv', 'a') do |fh|
			results.each do |row|
				row.unshift(Time.now.to_i)
				fh << row
			end
		end

#		p xml.length
	end
end

require 'nokogiri'
require 'awesome_print'


doc = Nokogiri::HTML(IO.read('../data/downloaded/shkolaspb/addresses/приморский-2013-01-30.html'))
ap doc

exit

file_names = Dir.glob('../data/downloaded/shkolaspb/addresses/*')

file_names.each do |file_name|
	doc = Nokogiri::HTML(IO.read(file_name))


	exit
end


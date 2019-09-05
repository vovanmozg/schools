require 'digest'

lines = []
IO.read('./tmp/ogrnformd.txt').split("\n").each do |ogrn|
	lines << "#{ogrn.strip}	#{Digest::MD5.hexdigest(ogrn.strip)}"
end
IO.write('./tmp/ogrnwithmd.txt', lines.join("\n"))

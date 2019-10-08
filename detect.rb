# example
# ruby detect.rb tmp/1.txt  > tmp/1-out.txt
# где tmp/1.txt содержит список названий школ по одной в каждой строке
# используется упрощённый алгоритм из combine-names.rb (только самые простые варианты основываясь на номере школы)

require('csv')
require('colored')
require_relative('files')

def select_by_number(name, names)
	matches = /(\d+)/.match(name)
	return [] unless matches

	number = matches[0]
	names.select { |item| /(\D|^)#{number}(\D|$)/.match(item['name'].strip) }
end

##################################################


names = CSV.read(NAMES, headers: true).map { |a| Hash[a] }

file_name = ARGV[0]

lines = IO.readlines(file_name)

lines.each do |line|
	found = select_by_number(line.strip, names)

	compacted =  found.map{ |h| h['id']}.uniq.compact

	if compacted.count == 1
		puts compacted[0]
	elsif compacted.count > 1
		puts 'error'.red
  else
    puts ''
	end

end


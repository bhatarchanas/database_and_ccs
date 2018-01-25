require 'bio'
require 'bio-alignment'

include Bio::BioAlignment

fasta_file = Bio::FlatFile.auto("ccs2_fifth16s_and_subset_aligned.fa")

copy_of_16s= ""
aln = Alignment.new
count = 0
fasta_file.each_with_index do |entry, index|
	#puts entry.definition, index
	if index == 0
		copy_of_16s = entry.naseq
	else
		count += 1
		aln << Bio::Sequence::NA.new(entry.naseq)
	end
end

#puts copy_of_16s
#puts aln.inspect
#puts count

counts_array = Array.new(count) {Array.new(copy_of_16s.size)}
#puts counts_array.size

counts_array.each.with_index do |row, i|
  	row.each.with_index do |cell, j|
  		#puts "#{aln[i][j].to_s}, #{copy_of_16s[j].to_s}"
  		if aln[i][j].to_s == copy_of_16s[j].to_s
  			counts_array[i][j] = 0
  		else
  			counts_array[i][j] = 1
  		end
  	end
end
#puts counts_array.inspect

counts_array << counts_array.transpose.map{|x| x.reduce(:+)}
counts_array.map! {|row| row + [row.reduce(:+)]}

out_file = File.open("ccs2_first16s_and_subset_aligned_added_rows_and_cols.txt", "w")
counts_array.each_with_index do |row, i|
	out_file.puts(row.inspect)
end
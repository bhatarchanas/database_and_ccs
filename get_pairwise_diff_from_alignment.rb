require 'bio'
require 'bio-alignment'

include Bio::BioAlignment

#fasta_file = Bio::FlatFile.auto("ccs2_fifth16s_and_subset_aligned.fa")

# loop through the fasta files in the directory 
Dir.glob('/data/shared/homes/archana/projects/DB_paper_all_materials/positive_controls/copy_number/*_aligned.fa') do |fas_file|
	# Get the basename of the file
	basename = File.basename(fas_file, ".fa")
	# Get the 16s copy, alignment sequences and number of reads (to create the 2d array)
	fas_file_open = Bio::FlatFile.auto(fas_file)
	copy_of_16s= ""
	aln = Alignment.new
	count = 0
	fas_file_open.each_with_index do |entry, index|
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

	# Create the 2d array of the required size
	counts_array = Array.new(count) {Array.new(copy_of_16s.size)}
	#puts counts_array.size

	# Populate 2d array
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

	# Sum the rows and columns and add new row and column with sums
	counts_array << counts_array.transpose.map{|x| x.reduce(:+)}
	counts_array.map! {|row| row + [row.reduce(:+)]}

	# Print
	out_file = File.open("#{basename}_added_rows_and_cols.txt", "w")
	counts_array.each_with_index do |row, i|
		out_file.puts(row.inspect)
	end
end
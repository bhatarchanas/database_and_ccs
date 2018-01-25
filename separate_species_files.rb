require "bio"

blast_file = File.open("/data/shared/homes/archana/projects/DB_paper_all_materials/positive_controls/Ecoli_16s_vs_OTU2_blast_2columns.txt")
aln_file = Bio::FlatFile.auto("/data/shared/homes/archana/projects/DB_paper_all_materials/positive_controls/Ecoli_OTU2_10pctsubset.fasta")

blast_hash = {}
blast_file.each_with_index do |line, index|
	if index == 0
		next
	else
		line_split = line.split("\t")
		if blast_hash.has_key?(line_split[1].chomp)
			blast_hash[line_split[1].chomp].push(line_split[0])
		else
			blast_hash[line_split[1].chomp] = [line_split[0]]
		end
	end
end
#puts blast_hash

aln_headers_hash = {}
aln_file.each do |entry|
	if aln_headers_hash.has_key?(entry.definition)
		puts "DANGER"
	else
		aln_headers_hash[entry.definition] = entry.naseq.upcase
	end
end
#puts aln_headers_hash

blast_hash.each do |key, value|
	puts key
	sp_file = File.open("ccs2_#{key}_subset.fa", "w")
	value.each do |each_header|
		if aln_headers_hash.has_key?(each_header)
			sp_file.puts(">#{each_header}")
			sp_file.puts(aln_headers_hash[each_header])
		else
			puts "no"
		end
	end
	sp_file.close()

	#`mafft --auto --thread 32 ccs2_#{key}_subset.fa > ccs2_#{key}_subset_aligned.fa` 
end

require "bio"

ccs1_file = Bio::FlatFile.auto("/data/shared/homes/archana/projects/BEI_mcsmrt_v1/pre_demultiplexed_ccsfilt.fq")
ccs2_file = Bio::FlatFile.auto("/data/shared/homes/archana/projects/BEI_ccs2/pre_demultiplexed_ccsfilt.fq")
outfile = File.open("qual_comparison.txt", "w")
outfile.puts("Header\tCCS1\tCCS2")

ccs1_hash = {}
ccs1_file.each do |entry|
	#puts entry.definition
	def_split = entry.definition.split(";")
	qual_scores_array = entry.quality_scores
	#puts qual_scores_array.inspect
	tot_score = 0
	qual_scores_array.each do |each_score|
		tot_score += each_score
	end
	if tot_score == 0
		next
	else
		avg_score = tot_score/entry.naseq.size
		#puts avg_score
		ccs1_hash[def_split[0]] = avg_score
	end
end

ccs2_hash = {}
ccs2_file.each do |entry|
	def_split = entry.definition.split(";")
	qual_scores_array = entry.quality_scores
	#puts qual_scores_array.inspect
	tot_score = 0
	qual_scores_array.each do |each_score|
		tot_score += each_score
	end
	if tot_score == 0
		next
	else
		avg_score = tot_score/entry.naseq.size
		#puts avg_score
		ccs2_hash[def_split[0]] = avg_score
	end
end

ccs2_hash.each do |key, value|
	if ccs1_hash[key].nil? or value.nil?
		next
	else
		outfile.puts("#{key}\t#{ccs1_hash[key]}\t#{value}")
	end
end
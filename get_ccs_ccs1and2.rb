require "bio"

ccs1_file = Bio::FlatFile.auto("/data/shared/homes/archana/projects/BEI_mcsmrt_v1/pre_demultiplexed_ccsfilt.fq")
ccs2_file = Bio::FlatFile.auto("/data/shared/homes/archana/projects/BEI_ccs2/pre_demultiplexed_ccsfilt.fq")
outfile = File.open("ccs_comparison.txt", "w")
outfile.puts("Header\tCCS1\tCCS2")

ccs1_hash = {}
ccs1_file.each do |entry|
	def_split = entry.definition.split(";")
	ee = def_split[-1].split("=")[1].split(";")[0]
	#puts def_split[0]+"\t"+ee
	if ccs1_hash.has_key?(def_split[0])
		puts def_split[0]
	else
		ccs1_hash[def_split[0]] = ee
	end
end

ccs2_hash = {}
ccs2_file.each do |entry|
	def_split = entry.definition.split(";")
	ee = def_split[-1].split("=")[1].split(";")[0]
	#puts def_split[0]+"\t"+ee
	if ccs2_hash.has_key?(def_split[0])
		puts def_split[0]
	else
		ccs2_hash[def_split[0]] = ee
	end
end

ccs2_hash.each do |key, value|
	if ccs1_hash[key].nil? or value.nil?
		next
	else
		outfile.puts("#{key}\t#{ccs1_hash[key]}\t#{value}")
	end
end


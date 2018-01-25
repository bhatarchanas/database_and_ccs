
Dir.glob("*_aligned_consensus.fa") do |item|
	#puts item
	basename = File.basename(item, ".fa")
	#puts basename
	`cat #{item} Ecoli_16scopies_extracted_aligned.fa > #{basename}_with_16scopies.fa`
	`mafft --auto --thread 16 #{basename}_with_16scopies.fa > #{basename}_with_16scopies_aligned.fa` 
end
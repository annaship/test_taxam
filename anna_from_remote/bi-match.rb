#! /usr/local/bin/ruby                                                                                                                 

require 'rubygems'
require 'taxamatch_rb'

def make_taxamatch_hash(string)
  if string
    normalized = Taxamatch::Normalizer.normalize(string)
    {:string     => string, 
     :normalized => normalized, 
     :phonetized => Taxamatch::Phonetizer.near_match(normalized)}
  end
end

def split_names(name)
  name_arr = name.split(" ")
  genera   = name_arr[0]
  species  = name_arr[1]
  return genera, species
end

def prepare(name)
  bad_genera, bad_species = split_names(name)
  bad_genera_h  = make_taxamatch_hash(bad_genera) 
  bad_species_h = make_taxamatch_hash(bad_species)
  return bad_genera_h, bad_species_h
end

file_bad  = ARGV[0]
file_good = ARGV[1]
file_res  = ARGV[2] || 'bi_match_res.txt'

unless ARGV.size == 2
  puts "Please provide 2 file names to compere" 

else 
  tm = Taxamatch::Base.new

  bad_names  = open(file_bad).read.split("\n")
  good_names = open(file_good).read.split("\n")
  f_res = open(file_res, 'w')

#  printf "bad_names = %s\n" % bad_names 
  bad_names.each do |bad_name|
    unless bad_name.nil?
      puts "=" * 80
      bad_name = bad_name.strip
      print "bad_name = %s\n" % [bad_name]
      bad_genera_h, bad_species_h = prepare(bad_name)
      good_names.each do |good_name|
        unless good_name.nil?
          print "good_name = %s\n" % [good_name]
          good_name = good_name.strip
          unless bad_name == good_name
	    #print "bad_name = %s, good_name = %s" % [bad_name, good_name]
            good_genera_h, good_species_h = prepare(good_name)
            gmatch = tm.match_genera(bad_genera_h, good_genera_h)
            smatch = tm.match_species(bad_species_h, good_species_h)
            res    = tm.match_matches(gmatch, smatch)
            f_res.write bad_name+"--->"+good_name+"\n" if res["match"]
          else
            f_res.write bad_name+"--->"+good_name+"\n"
          end
        end
      end
    end
  end
end


# f.each do |l|
#   l = l.strip
#   pf.write a.parse(l)
# end


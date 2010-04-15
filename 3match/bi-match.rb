#! /opt/local/bin/ruby #! /usr/local/bin/ruby                                                                                                                 

require 'rubygems'
require 'taxamatch_rb'

def make_taxamatch_hash(string)
  normalized = Taxamatch::Normalizer.normalize(string)
  {:string     => string, 
   :normalized => normalized, 
   :phonetized => Taxamatch::Phonetizer.near_match(normalized)}
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
file_res  = ARGV[2] || 'uni_match_res.txt'

unless ARGV.size == 3
  puts "Please provide 3 file names (2 for comperison and one for output)" 

else 
  tm = Taxamatch::Base.new

  bad_names  = open(file_bad).read.split("\n")
  good_names = open(file_good).read.split("\n")
  f_res = open(file_res, 'w')

  bad_names.each do |bad_name|
    unless bad_name.nil?
      bad_name = bad_name.strip
      bad_genera_h, bad_species_h = prepare(bad_name)
      good_names.each do |good_name|
        unless good_name.nil?
          good_name = good_name.strip
          unless bad_name == good_name
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


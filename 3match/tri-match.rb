#! /opt/local/bin/ruby #! /usr/local/bin/ruby                                                                                                                 

require 'rubygems'
require 'taxamatch_rb'

file_bad  = ARGV[0]
file_good = ARGV[1]
file_res  = ARGV[2] || 'uni_match_res.txt'

@tm = Taxamatch::Base.new

bad_names  = open(file_bad).read.split("\n")
good_names = open(file_good).read.split("\n")
f_res = open(file_res, 'w')

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

def make_taxamatch_hash(string)
  normalized = Taxamatch::Normalizer.normalize(string)
  {:string     => string, 
   :normalized => normalized, 
   :phonetized => Taxamatch::Phonetizer.near_match(normalized)}
end

def preparse(name)
  prepars = {}
  name_arr = name.split(" ")
  
  name_arr.each_index do |n|
    prepars[:genus]        = make_taxamatch_hash(name_arr[n])   if n == 0 
    prepars[:species]      = make_taxamatch_hash(name_arr[n])   if n == 1 
    prepars[:infraspecies] = [make_taxamatch_hash(name_arr[n])] if n == 2 
  end
end
# at.parse('Atys andersonii sanders Linne 1773')
# => {:all_years=>["1773"], :genus=>{:phonetized=>"ATIS", :normalized=>"ATYS", :normalized_authors=>[], :authors=>[], :string=>"Atys", :years=>[]}, :species=>{:phonetized=>"ANDIRSANI", :normalized=>"ANDERSONII", :normalized_authors=>[], :authors=>[], :string=>"andersonii", :years=>[]}, :all_authors=>["LINNE"], :infraspecies=>[{:phonetized=>"SANDIRS", :normalized=>"SANDERS", :normalized_authors=>["LINNE"], :authors=>["Linne"], :string=>"sanders", :years=>["1773"]}]}

def compare_genera(genera1, genera2)
  @tm.match_genera(genera1, genera2)
end

def compare_species(species1, species2)
  @tm.match_species(species1, species2)
end

def compare_matches(gmatch, smatch)
  # gmatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
  # smatch = {'match' => true, 'phonetic_match' => true, 'edit_distance' => 1}
  # @tm.match_matches(gmatch, smatch).should == {'phonetic_match' => true, 'edit_distance' => 2, 'match' => true}
  @tm.match_matches(gmatch, smatch)
end

def compare_multinomials(name1, name2)
  pre1 = preparse(name1)
  pre2 = preparse(name2)
  puts pre1[:genus]
  @tm.match_multinomial(pre1, pre2)
end

bad_names.each do |bad_name|
  unless bad_name.nil?
    bad_name = bad_name.strip
    preparse(bad_name) 
    bad_genera_h, bad_species_h = prepare(bad_name)
    # printf "bad_genera_h = %s, bad_species_h = %s\n" % [bad_genera_h, bad_species_h]
    good_names.each do |good_name|
      unless good_name.nil?
        good_name = good_name.strip
        good_genera_h, good_species_h = prepare(good_name)
        unless bad_name == good_name
          res = compare_multinomials(bad_name, good_name)
          # printf "res = %s\n" % compare_matches(gmatch, smatch)["match"]
          # printf "%s ---> %s\n" % [bad_name, good_name] if res["match"]
          # res = tm.match_genera(b_hash, g_hash)
          f_res.write bad_name+"--->"+good_name+"\n" if res["match"]
        else
          f_res.write bad_name+"--->"+good_name+"\n"
        end
        # printf "res = %s, %s ---> %s\n" % [res["match"].to_s, bad_name, good_name]
      end
    end
      end
end


# f.each do |l|
#   l = l.strip
#   pf.write a.parse(l)
# end

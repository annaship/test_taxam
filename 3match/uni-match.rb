#! /opt/local/bin/ruby

require 'rubygems'
require 'taxamatch_rb'

def make_taxamatch_hash(string)
  normalized = Taxamatch::Normalizer.normalize(string)
  {:string     => string, 
   :normalized => normalized, 
   :phonetized => Taxamatch::Phonetizer.near_match(normalized)}
end

file_bad  = ARGV[0]
file_good = ARGV[1]
file_res  = ARGV[2] || 'uni_match_res.txt'

tm = Taxamatch::Base.new

bad_names  = open(file_bad).read.split("\n")
good_names = open(file_good).read.split("\n")
f_res = open(file_res, 'w')

bad_names.each do |bad_name|
  bad_name = bad_name.strip
  # printf "bad_name = %s\n" % bad_name
  unless bad_name.nil?
  b_hash   =  make_taxamatch_hash(bad_name)
  good_names.each do |good_name|
    unless good_name.nil?
    good_name = good_name.strip
    g_hash   =  make_taxamatch_hash(good_name)
    unless bad_name == good_name
      res = tm.match_genera(b_hash, g_hash)
      f_res.write good_name+"--->"+bad_name+"\n" if res["match"]
    else
      f_res.write good_name+"--->"+bad_name+"\n"      
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

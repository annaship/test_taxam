#!/opt/local/bin/ruby

#!/usr/bin/env ruby
require 'rubygems'
require 'taxamatch_rb'

data_file = open('matched_tmp.txt', 'w')

tm = Taxamatch::Base.new

def prepare_data(file)
  res = {}
  open(file).each do |l| 
    g, s = l.strip.split(/\s+/)
    res[g] ? res[g] << s : res[g] = [s]
  end
  res
end

def match_sp(tm, bad, genera, g_bad, g_good, match, count, data_file)
  puts "g_good = %s" % g_good
  bad[g_bad].each do |s_bad|
    s1 = {:normalized => s_bad, :phonetized => 'a'}
    genera[g_good].keys.each do |size|
      genera[g_good][size].each do |s_good|
        s2 = {:normalized => s_good, :phonetized => 'b'}
        sp_match = tm.match_species(s1, s2)
        if tm.match_matches(match, sp_match)["match"] 
          data_file.write("%s %s--->%s %s\n" % [g_bad, s_bad, g_good, s_good]) 
          count += 1
        end
      end
    end
  end
  count
end

gen_size = {}
genera = {}
sp = {}

open('good2.txt').each do |l|
  n = l.strip
  g_good, s_good = n.split(/\s+/)
  s_good_size    = s_good.size
  g_good_size    = g_good.size
  if genera[g_good]
    if genera[g_good][s_good_size]
      genera[g_good][s_good_size] << s_good
    else
      genera[g_good][s_good_size] = [s_good]
    end
  else
    genera[g_good] = {s_good_size => [s_good]}
    if gen_size[g_good_size]
      gen_size[g_good_size] << g_good
    else
      gen_size[g_good_size] = [g_good]
    end
  end
end

bad = prepare_data('bad2.txt')

# gen_size.keys.sort.each do |k|
#   puts k, gen_size[k].size
# end
puts 'ok done with collecting data....'
t = Time.now
bad.keys.sort.each do |g_bad|
  count      = 0
  g_bad_size = g_bad.size
  delta      = (g_bad_size / 4.0).ceil
  res        = []
  (g_bad_size - delta..g_bad_size + delta).each do |size|
    res += gen_size[size] 
  end
  matches = []
  g1 = {:normalized => g_bad, :phonetized => 'a'}
  res.each do |g_good|
    g2 = {:normalized => g_good, :phonetized => 'b'}
    match = tm.match_genera(g1, g2)
    count = match_sp(tm, bad, genera, g_bad, g_good, match, count, data_file) if match["match"]
  end
  puts "bad = %s\t matched w sp = %s,\tg_bad_size = %s\t-> %s" % [g_bad, count, g_bad_size, (Time.now - t)]
  t = Time.now
end

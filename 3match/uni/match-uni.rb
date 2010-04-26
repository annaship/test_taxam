#!/opt/local/bin/ruby

#!/usr/bin/env ruby
require 'rubygems'
require 'taxamatch_rb'

data_file = open('matched_uni.txt', 'w')

tm = Taxamatch::Base.new

def prepare_data(file)
  names = {}
  open(file).each do |l| 
    name = l.strip
    name_size    = name.size
    if names[name_size]
      names[name_size] << name
    else
      names[name_size] = [name]
    end
  end
  names
end

# def prepare_hash(name)
# name_hash = {:normalized => name, :phonetized => 'a'}
# end

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




puts "=" * 80

# open('good1.txt').each do |l|
#   n_good = l.strip
#   n_good_size    = n_good.size
#   if names[n_good_size]
#     names[n_good_size] << n_good
#   else
#     names[n_good_size] = [n_good]
#   end
# end 

# puts name.inspect

# name.each do |key, value| 
#   puts key 
# end

good = prepare_data('good1.txt')
bad = prepare_data('bad1.txt')

# good.keys.sort.each do |k|
#   puts "good name size = %s has %s members" % [k, good[k].size]
# end
# 
# bad.keys.sort.each do |k|
#   puts "bad name size = %s has %s members" % [k, bad[k].size]
# end

puts 'ok done with collecting data....'
t = Time.now


bad.each do |n_bad_size, n_bad|
  delta_bad         = (n_bad_size / 2.0).ceil
  slice_bad         = (n_bad_size - delta_bad..n_bad_size + delta_bad)
  good.each do |n_good_size, n_good|
    delta_good      = (n_good_size / 2.0).ceil
    slice_good      = (n_good_size - delta_good..n_good_size + delta_good)
    if (slice_bad == slice_good)
      # puts slice_good
      n_bad.each do |name_bad|
        # puts n_bad
        hash_b = {:normalized => name_bad, :phonetized => 'a'}
        n_good.each do |name_good|
          hash_g = {:normalized => name_good, :phonetized => 'b'}      
          unless name_bad.empty? || name_good.empty?
            puts "name_bad = %s, name_good = %s\n" % [name_bad, name_good]
            match = tm.match_uninomial(hash_b, hash_g)
            # puts match.inspect
            if match["match"]
              data_file.write("%s--->%s\n" % [name_bad, name_good]) 
              # puts "%s ---> %s\n" % [name_bad, name_good]
            end
            # match_uninomial
            # unless bad_name == good_name
            #   res = tm.match_genera(b_hash, g_hash)
            #   f_res.write good_name+"--->"+bad_name+"\n" if res["match"]
            # else
            #   f_res.write good_name+"--->"+bad_name+"\n"      
            # end
          end

        end
      end
    end 
    # puts "n_bad_size = %s, n_bad = %s, n_good_size = %s, n_good = %s" % [n_bad_size, n_bad, n_good_size, n_good]
  end
end

# bad.keys.sort.each do |n_bad|
#   n_bad_size        = n_bad
#   delta_bad         = (n_bad_size / 4.0).ceil
#   res               = []
#   (n_bad_size - delta_bad..n_bad_size + delta_bad).each do |size|
#     res += good[size] if good[size]
#     # puts "n_bad = %s, good[size] = %s" % [n_bad, good[size]]
#   end
#   # puts res
#   # good.keys.sort.each do |n_good|
#   #   n_good_size     = n_good
#   #   delta_good      = (n_good_size / 4.0).ceil
#   # 
#   # end
#   matches = []
#   n1 = {:normalized => g_bad, :phonetized => 'a'}
#   res.each do |g_good|
#     n2 = {:normalized => g_good, :phonetized => 'b'}
#     # puts "g_bad = %s, g_good = %s\n" % [g_bad, g_good]
#     match = tm.match_genera(g1, g2)
#     count = match_sp(tm, bad, genera, g_bad, g_good, match, count, data_file) if match["match"]
#   end
#   puts "bad = %s\t matched w sp = %s,\tg_bad_size = %s\t-> %s" % [g_bad, count, g_bad_size, (Time.now - t)]
#   t = Time.now
#   
# end
# 
# # 
# bad.keys.sort.each do |g_bad|
#   puts "=" * 80
#   count      = 0
#   g_bad_size = g_bad
#   delta      = (g_bad_size / 4.0).ceil
#   # puts "(g_bad_size - delta..g_bad_size + delta) = %s\n" % [g_bad_size - delta..g_bad_size + delta].inspect
#   # puts "g_bad = %s, delta = %s\n" % [g_bad, delta]
#   res        = []
#   (g_bad_size - delta..g_bad_size + delta).each do |size|
#     res += gen_size[size] 
#     # puts "gen_size[size] = %s, res = %s\n" % [gen_size[size], res.inspect]
#   end
# #   matches = []
# #   g1 = {:normalized => g_bad, :phonetized => 'a'}
# #   res.each do |g_good|
# #     g2 = {:normalized => g_good, :phonetized => 'b'}
# #     # puts "g_bad = %s, g_good = %s\n" % [g_bad, g_good]
# #     match = tm.match_genera(g1, g2)
# #     count = match_sp(tm, bad, genera, g_bad, g_good, match, count, data_file) if match["match"]
# #   end
# #   puts "bad = %s\t matched w sp = %s,\tg_bad_size = %s\t-> %s" % [g_bad, count, g_bad_size, (Time.now - t)]
# #   t = Time.now
# end
# -----
# def taxamatch_preparsed(preparsed_1, preparsed_2)
#   result = nil
#   result = match_uninomial(preparsed_1, preparsed_2) if preparsed_1[:uninomial] && preparsed_2[:uninomial]
#   result = match_multinomial(preparsed_1, preparsed_2) if preparsed_1[:genus] && preparsed_2[:genus]
#   if result && result['match']
#     result['match'] = match_authors(preparsed_1, preparsed_2) == 0 ? false : true
#   end
#   return result
# end
# 
# def match_uninomial(preparsed_1, preparsed_2)
#   match_genera(preparsed_1[:uninomial], preparsed_2[:uninomial])
# end
# def match_genera(genus1, genus2)
#   genus1_length = genus1[:normalized].size
#   genus2_length = genus2[:normalized].size
#   min_length = [genus1_length, genus2_length].min
#   match = false
#   ed = @dlm.distance(genus1[:normalized], genus2[:normalized],1,3) #TODO put block = 2
#   return {'edit_distance' => ed, 'phonetic_match' => false, 'match' => false} if ed/min_length.to_f > 0.2
#   return {'edit_distance' => ed, 'phonetic_match' => true, 'match' => true} if genus1[:phonetized] == genus2[:phonetized]
# 
#   match = true if ed <= 3 && (min_length > ed * 2) && (ed < 2 || genus1[0] == genus2[0])
#   {'edit_distance' => ed, 'match' => match, 'phonetic_match' => false}
# end
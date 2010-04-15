#!/usr/bin/ruby

class String
  def count_words
    n = 0
    scan(/\b\S+\b/) {n += 1}
    n
  end 
end

class Array

  require "rubygems"
  require "taxamatch_rb"
  require "text"

  def reconsilliation(file_name = $*[1])
    taxam = Taxamatch::Base.new
    i = 0
    arr = []
    result = []
    name_list = self
    second_list = get_name_list(file_name)
    name_list.each do |bad_name|
      count_bad_words = bad_name.count_words
      second_list.each do |good_name|
        # 1 filter
        unless bad_name == good_name
          count_good_words = good_name.count_words
          # 2 filter
          if count_bad_words == count_good_words
              if taxam.taxamatch(bad_name, good_name)
                text = bad_name.to_s + " ---> " + good_name.to_s
              end
         end
        else
          text = bad_name.to_s + " ---> " + good_name.to_s
        end
        result << text
        text = ""        
      end
      result.compact! 
      # arr = []
      i += 1
    end
    return result
  end
 
  def take_all_names
    t1 = Time.now  
    uniq_result = []
    names_list = self
    uniq_result_all = names_list.reconsilliation.uniq  
    puts uniq_result_all.inspect.to_s unless uniq_result_all.empty?
    exit
  end

  private

   def parse_match(parsed_line1, parsed_line2)
     p = Taxamatch::Atomizer.new
     parsed_name1 = p.parse(parsed_line1)
     parsed_name2 = p.parse(parsed_line2)
     begin    
       t = Taxamatch::Base.new
       return t.taxamatch_preparsed(parsed_name1, parsed_name2)["match"] #true
     rescue
       return false
     end
   end

   def taxamatch_match(arr, name1, name2)
     begin        
       if Taxamatch::Base.new.taxamatch(name1, name2) then
         arr << name2
         arr << name1
       end
     rescue
       puts name1
       nil
     end
     return arr
   end

   def lev_dist_match(arr, name1, name2, num)
     if Text::Levenshtein.distance(name1, name2) < num
       arr << name2
       arr << name1
     end
     return arr
   end

end

names_list = []  

def get_name_list(file_name)
    names_list = []  
    file1 = File.open(file_name, 'r')                                                    
    file1.readlines.each do |line|
      line.chomp!
      line.gsub!(/[^A-Za-z ]/, "")
      names_list << line
    end
    return names_list
  end
  
if ARGV.size < 2
  puts "Provide two files to compare, bad and good ones, please"
else
  first_name = ARGV[0]
  get_name_list(first_name).take_all_names
end


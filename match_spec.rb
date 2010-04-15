require 'rubygems'
require 'taxamatch_rb'
require File.dirname(__FILE__) + '/tri-match-sep.rb'

describe 'Taxamatch' do
  
  before(:all) do
    @tm = Taxamatch::Base.new
    @genera1 = 'Atyssss'
    @genera2 = 'Ahyssss'
    @trinomial1_1 = 'Akotropis fumata impersonata'
    @trinomial1_2 = 'Akotropiis fumata impersonata'
    @trinomial2_1 = 'Vespa florisequa maior'
    @trinomial2_2 = 'Vespa florisequa minor'
  end  
    
  
  
  it 'should convert trinomials to hash' do
    preparse('Atys andersonii ura').should == {:genus=>{:string=>"Atys", :phonetized=>"ATIS", :normalized=>"ATYS"}, :species=>{:string=>"andersonii", :phonetized=>"ANDIRSANI", :normalized=>"ANDERSONII"}, :infraspecies=>[{:string=>"ura", :phonetized=>"URA", :normalized=>"URA"}]}
  end
  
  # it 'should compare uninomials' do
  #   compare_uninomials(@name1, @name2).should == ''
  # end

  it 'should compare multinomials' do
    compare_multinomials(@trinomial1_1, @trinomial1_2).should == 
      {"edit_distance"=>1, "phonetic_match"=>true, "match"=>true}
  end

  it 'should compare multinomials and give false if not matching' do
    compare_multinomials(@trinomial2_1, @trinomial2_2).should == {"edit_distance"=>2, "phonetic_match"=>false, "match"=>false}
  end

  
  it 'should compare genera' do
    hash1 = make_taxamatch_hash(@genera1)
    hash2 = make_taxamatch_hash(@genera2)
    
    compare_genera(hash1, hash2).should == {"edit_distance"=>1, "phonetic_match"=>false, "match"=>true}
  end
  
  

end
#!/usr/bin/env ruby

require 'taxamatch_rb'

file = ARGV[0]
parsed = ARGV[1] || 'parsed.txt'

a = Taxamatch::Atomizer.new
f = open(file)
pf = open(parsed, 'w')
f.each do |l|
  l = l.strip
  pf.write a.parse(l)
end 

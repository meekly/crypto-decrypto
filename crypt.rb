#!/usr/bin/env ruby
# coding: utf-8

INFILE = 'text.txt'
OUTFILE = 'text.cry'

A = 9                           # Random a
B = 14                          # Random b
M = ('а'..'я').to_a.length           # Letters in russian alphabet

def read_file()
  File.read(INFILE)
end

def clear_symbols(text)
  text.downcase.gsub(/[^а-я ]/, '')
end

def crypt(text)
  arr = ('а'..'я').to_a
  alpha = {}
  arr.each_with_index { |a, i| alpha[a] = i }

  cryparr = []
  arr.length.times do |i|
    cryparr[i] = (A*i + B) % M
  end

  text.gsub(/[а-я]/) do |ch|
    arr[ cryparr[ alpha[ ch ] ] ]
  end
end

def main()
  crypted_text = crypt clear_symbols read_file
  File.open( OUTFILE, 'w') { |file| file.write(crypted_text) }
end


main()

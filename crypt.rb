#!/usr/bin/env ruby
# coding: utf-8

INFILE = 'text.txt'
OUTFILE = 'text.cry'

A = 7                           # Pseudo random a
B = 27                          # Pseudo random b
M = ('а'..'я').to_a.length      # Letters in russian alphabet

def read_file(file)
  File.read(file)
end

def clear_symbols(text)
  text.downcase.gsub(/[^а-я ]/, '')
end

def crypt(text)
  arr = ('а'..'я').to_a

  cryparr = []
  arr.length.times do |i|
    cryparr[i] = (A*i + B) % M
  end

  text.gsub(/[а-я]/) do |ch|
    arr[ cryparr[ arr.index(ch) ] ]
  end
end

def main()
  crypted_text = crypt clear_symbols read_file INFILE
  File.open( OUTFILE, 'w') { |file| file.write(crypted_text) }
end


main()

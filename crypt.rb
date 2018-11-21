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

def crypt(a, b, text)
  arr = ('а'..'я').to_a

  cryparr = []
  arr.length.times do |i|
    cryparr[i] = (a*i + b) % M
  end

  text.gsub(/[а-я]/) do |ch|
    arr[ cryparr[ arr.index(ch) ] ]
  end
end

def nod(a, b)
  while a != 0 and b != 0 do
    if a > b then
      a = a % b
    else
      b = b % a
    end
  end
  a + b
end

def main()
  puts 'Input A:'
  a = gets.to_i
  puts 'Input B:'
  b = gets.to_i

  if nod(a, M) != 1 then
    puts "Error: A(#{A}) and M(#{M}) must have NOD = 1"
    exit 1
  end
  crypted_text = crypt(a, b, clear_symbols( read_file( INFILE)))
  File.open( OUTFILE, 'w') { |file| file.write(crypted_text) }
end


main()

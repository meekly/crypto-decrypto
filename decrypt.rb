require_relative './lib.rb'

puts 'Input A:'
A = gets.to_i
puts 'Input B:'
B = gets.to_i

FILE = 'text.cry'

puts 'Here we go:'
puts decrypt_text(A, B, File.read(FILE))

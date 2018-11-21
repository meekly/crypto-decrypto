#!/usr/bin/env ruby
# coding: utf-8

require_relative './lib.rb'

INFILE  = 'text.cry'
OUTFILE = 'decrypted.txt'
RUDICT  = 'ru.dic'

def read_file(file)
  File.read(file)
end


DICT_WORDS = File.read(RUDICT).split("\n")
def dict_has(word)
  DICT_WORDS.index(word)
end

def translation_fine(text)
  words = text.split
  matched = 0
  words.each do |word|
    matched += 1 if dict_has(word)
  end

  summary = words.length
  return (matched.to_f / summary.to_f) > 0.5
end

def get_decrypting_vars(base, change, text)

  # Trying to guess A and B using frequencies
  base_x0 = ARR.index(base[0])
  change_x0 = ARR.index(change[0])
  base_x1 = ARR.index(base[1])
  change_x1 = ARR.index(change[1])

  # To find A we need to use this formula:
  #     change_x0 - change_x1 - 32n
  # A = -------------------------
  #        base_x0 - base_x1
  # n is a number from 0 to 32, so A is a natural number

  formula = lambda { |a0, a1, b0, b1, n|
    (b0 - b1 - ARR.length * n).to_f / (a0 - a1).to_f
  }

  n = -ARR.length
  fine = nil
  while n < ARR.length and ! fine
    a = formula.call(base_x0, base_x1, change_x0, change_x1, n)

    if a % 1 == 0 and a > 0 and ARR.length % a != 0 then
      fine = true
    end

    if fine then
      b = ARR.length * n + base_x0 - a * change_x0
      if b > 0
        return a, b
      else
        fine = false
      end
    end
    n += 1
  end
end



# Trying to decrypt by guessing
# Using available commonly-used letter-frequency
# Comparing it to the computed frequency and searching words in dict
def decrypt(text, freq)
  # {'a' => 0.21312} ==> [['a', 0.21312]]
  sorted_known = KNOWN_FREQUENCY.sort_by {|k,v| v}.reverse
  sorted_got   = freq.sort_by {|k,v| v}.reverse
  result = nil
  sorted_got.each_with_index do |_, index|
    a, b =  get_decrypting_vars(
         sorted_got[index,2].map {|k, v| k},
         sorted_known[index,2].map {|k, v| k},
         text)
    a_swp, b_swp = get_decrypting_vars(
             sorted_got[index,2].map {|k, v| k}.reverse,
             sorted_known[index,2].map {|k, v| k}.reverse,
             text)

    if a and b
      result = decrypt_text(a, b, text)
    elsif a_swp and b_swp
      result = decrypt_text(a_swp, b_swp, text)
    end


    if result and translation_fine(result.split(' ').first(10).join(' ')) then
      puts "Frequency algorithm worked!"
      puts "A: #{a}#{a_swp}, B: #{b}#{b_swp}"
      return result
    end

    break if index+2 == sorted_got.length
  end

  # Naive running through possible pairs of As and Bs
  few_words = text.split.first(14).join(' ')
  rng = (0...ARR.length).to_a
  rng.product(rng).each do |a,b|
    decrypted_text = decrypt_text(a, b, few_words)

    # Guess using dictionary if the words decrypted are real
    if translation_fine(decrypted_text) then
      puts "Naive algorithm worked."
      return decrypt_text(a, b, text)
    end
  end

  # Return nil or these very values A and/or B
  nil
end


def main()
  text = read_file INFILE
  frequency = count_summary text
  puts decrypt( text, frequency )
end

main()

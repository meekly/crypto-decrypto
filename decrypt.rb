#!/usr/bin/env ruby
# coding: utf-8

INFILE = 'text.cry'
OUTFILE = 'decrypted.txt'
KNOWN_FREQUENCY = {
  'о' => 0.10983,  'е' => 0.08483,  'а' => 0.07998,  'и' => 0.07367,
  'н' => 0.067,  'т' => 0.06318,  'с' => 0.05473,  'р' => 0.04746,
  'в' => 0.04533,  'л' => 0.04343,  'к' => 0.03486,  'м' => 0.03203,
  'д' => 0.02977,  'п' => 0.02804,  'у' => 0.02615,  'я' => 0.02001,
  'ы' => 0.01898,  'ь' => 0.01735,  'г' => 0.01687,  'з' => 0.01641,
  'б' => 0.01592,  'ч' => 0.0145,  'й' => 0.01208,  'х' => 0.00966,
  'ж' => 0.0094,  'ш' => 0.00718,  'ю' => 0.00639,  'ц' => 0.00486,
  'щ' => 0.00361,  'э' => 0.00331,  'ф' => 0.00267,  'ъ' => 0.00037,
  'ё' => 0.00013,
}


def read_file(file)
  File.read(file)
end

# Counts the frequency of every letter appearing in text
def count_summary(text)
  all = 0
  counts = Hash.new
  text.each_char do |ch|
    next if ch == ' '

    if !counts[ch] then
      counts[ch] = 1
    else
      counts[ch] += 1
    end

    all += 1
  end
  counts.each { |k, v| counts[k] = v.to_f / all}
end

def is_decryptable(base, change, text)
  arr = ('а'..'я').to_a

  base_x = arr.index(base)
  change_x = arr.index(change)

  # Manipulate with it, get the A and/or B

  # Guess using dictionary if the words decrypted are real

  # Return nil or these very values A and/or B
end

##
# Trying to decrypt by guessing
# Using available commonly-used letter-frequency
# Comparing it to the computed frequency and searching words in dict
def decrypt(text, freq)
  # {'a' => 0.21312} ==> [['a', 0.21312]]
  sorted_known = KNOWN_FREQUENCY.sort_by {|k,v| v}.reverse
  sorted_got   = freq.sort_by {|k,v| v}.reverse

  sorted_got.each_with_index do |freq, index|

    a, b =  is_decryptable( freq[0], sorted_known[index][0], text)
    if a and b
      return decrypt_text( text, a, b)
    end

  end
end


def main()
  frequency = count_summary read_file INFILE
  puts decrypt( text, frequency )
end

main()

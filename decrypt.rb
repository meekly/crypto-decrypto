#!/usr/bin/env ruby
# coding: utf-8

INFILE  = 'text.cry'
OUTFILE = 'decrypted.txt'
RUDICT  = 'ru.dic'

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
ARR = ('а'..'я').to_a

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

DICT_WORDS = File.read(RUDICT).split("\n")
def dict_has(word)
  DICT_WORDS.index(word)
end

def decrypt_text(a, b, text)
  a = 1 if a == 0               # We mean 1, when a is 0 while crypting

  cryparr = []
  ARR.length.times do |i|
    n = 0
    while (ARR.length*n + i - b) % a != 0 && n <= 32
      n += 1
    end
    cryparr[i] = (ARR.length*n + i - b) / a
  end

  text.gsub(/[а-я]/) do |ch|
    ARR[ cryparr[ARR.index(ch)] ]
  end
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
  base_x = ARR.index(base)
  change_x = ARR.index(change)


  # Naive running through possible pairs of As and Bs
  few_words = text.split.first(4).join(' ')
  rng = (0...ARR.length).to_a
  rng.product(rng).each do |a,b|
    decrypted_text = decrypt_text(a, b, few_words)

    # Guess using dictionary if the words decrypted are real
    if translation_fine(decrypted_text) then
      return a, b
    end
  end

  # Return nil or these very values A and/or B
  nil
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

    a, b =  get_decrypting_vars( freq[0], sorted_known[index][0], text)
    if a and b
      return decrypt_text(a, b, text)
    else
      raise Exception("Coundn't find correct decripting vars")
    end

  end
end


def main()
  text = read_file INFILE
  frequency = count_summary text
  puts decrypt( text, frequency )
end

main()

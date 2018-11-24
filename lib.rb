# coding: utf-8
ARR = ('а'..'я').to_a

# From Internet resources
KNOWN_FREQUENCY = {
  'о' => 0.10983,
  'е' => 0.08483,
  'а' => 0.07998,
  'и' => 0.07367,
  'т' => 0.067,
  'н' => 0.06318,
  'с' => 0.05473,
  'р' => 0.04746,
  'в' => 0.04533,
  'л' => 0.04343,
  'к' => 0.03486,
  'м' => 0.03203,
  'д' => 0.02977,
  'п' => 0.02804,
  'у' => 0.02615,
  'я' => 0.02001,
  'ы' => 0.01898,
  'г' => 0.01687,
  'з' => 0.01641,
  'б' => 0.01592,
  'ч' => 0.0145,
  'й' => 0.01208,
  'х' => 0.00966,
  'ъ' => 0.00037,
  'ж' => 0.0094,
  'ш' => 0.00718,
  'ь' => 0.01735,
  'ю' => 0.00639,
  'ц' => 0.00486,
  'щ' => 0.00361,
  'э' => 0.00331,
  'ф' => 0.00267,
}

# # Made for text.txt
# KNOWN_FREQUENCY = {
# 'о' => 2013,
# 'е' => 1563,
# 'а' => 1520,
# 'и' => 1326,
# 'н' => 1216,
# 'т' => 1178,
# 'с' => 937,
# 'л' => 928,
# 'р' => 875,
# 'в' => 778,
# 'м' => 621,
# 'п' => 555,
# 'к' => 547,
# 'д' => 540,
# 'у' => 505,
# 'я' => 400,
# 'ы' => 393,
# 'г' => 377,
# 'ь' => 353,
# 'ч' => 336,
# 'з' => 331,
# 'б' => 272,
# 'й' => 247,
# 'ж' => 208,
# 'ю' => 162,
# 'х' => 161,
# 'ш' => 129,
# 'ц' => 74,
# 'щ' => 72,
# 'э' => 61,
# 'ф' => 39,
# 'ъ' => 3,
# }


# Decrypts text by given A and B values
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

  ARR.each do |ch|
    if ! counts[ch] then
      counts[ch] = 0
    end
  end
  counts
end

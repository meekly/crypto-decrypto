task :crypt do
  puts 'Encrypting...'
  ruby 'crypt.rb'
  puts File.read('text.cry')
end

task :decrypt do
  puts 'Decrypting:'
  ruby 'decrypt.rb'
end

task :hack do
  puts 'Hacking... May take a while'
  ruby 'hack.rb'
end

task :clean do
  rm Dir.glob('*~')
  rm Dir.glob('#*')
  rm Dir.glob('.#*')
  File.exist? 'text.cry' and rm 'text.cry'
end

task :default => [:crypt, :hack]

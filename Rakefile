task :crypt do
  ruby 'crypt.rb'
end

task :clean do
  rm Dir.glob('*~')
  File.exist? 'text.cry' and rm 'text.cry'
end

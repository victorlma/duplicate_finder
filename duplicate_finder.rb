require 'digest'
require 'io/console'


table = {}
dirs = []
File.open("duplicates.log","w") do |log|

  Dir.glob("**").each do |path|
    dir = File.join(Dir.pwd, path)
    if File.directory?(dir)
      dirs.append(dir)
    end
  end

  if dirs.empty?
    puts "Current dir doesn't have any directories"
    exit(1)
  end
  puts "Choose a Dir to Check for duplicate files"
  dirs.each_with_index do |dir, count|
    puts "[#{count}] #{dir}"
  end
  begin 
    index = Integer(gets.chomp!) 
    workdir = dirs[index]
    if workdir == nil
      raise "Invalid Directory"
    end
  rescue
    puts "You need to Chose a Directory!"
    exit false
  end
  Dir.chdir(workdir)
  files = Dir.glob("**/*")
  files.each_with_index do |path, index|
  
    file = File.join(Dir.pwd,path)
    if !File.directory?(file)
      hash = Digest::SHA256.file(file)
      
      if table.key?(hash.to_s.to_sym)
        log.puts "#{file} is duplicate of #{table[hash.to_s.to_sym]}"
      end
      IO::console.clear_screen()
      percent = (index.to_f/files.size.to_f).round(3)
      puts "Checking: #{file}"
      puts ""
      puts "#{percent}%  Done"
    end
  end
end

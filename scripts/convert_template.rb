require 'fileutils'

def replace_format(path)
  params = []
  header = true
  description = nil
  query_lines = []
  contents = File.read(path)
  contents.each_line do |line|
    if matched = line.strip.match(/^#(param|args|ARGS)\s+(.*)$/)
      params << matched[2].split
    elsif header && (matched = line.match(/^# (.*)$/))
      header = false
      description = matched[1]
    else
      query_lines << line
    end
  end
  params = params.flatten

  params_part = params.each_with_index.map do |param, i|
    "# @param arg#{i}=#{param} \n"
  end.join('')

  <<~QUERY
    # @title #{description}
    #{params_part}
    #{query_lines.join('')}
  QUERY
end


Dir.glob(File.join(ARGV[0]  , '*')).select{ |file| !File.file?(file) }.each do |dir|
  dir_name = File.basename(dir)
  base_dir = File.join(ARGV[1], dir_name)
  FileUtils.mkdir_p(base_dir)
  Dir.glob(File.join(dir, '*')).select{ |file| File.file?(file) }.each do |template|
    puts "temp: #{template}"
    dst_path = File.join(base_dir, File.basename(template))
    if(template.end_with?('.rq'))
      File.write(dst_path, replace_format(template))
    else
      File.write(dst_path, File.read(template))
    end
  end
end
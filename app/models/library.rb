class Library

  def self.all
    entries = parse_config(File.join(Settings.library_root,'index.ini'))
    entries.map do |dir, name|
      count = Dir.glob(File.join(Settings.library_root, dir, '*.rq')).select{ |file| File.file?(file) }.size
      config = parse_config(File.join(Settings.library_root, dir, 'index.ini')).symbolize_keys
      if config.nil?
        nil
      else
        {
          uri: "#{ Settings.root_url }/library/#{dir}",
          name: name,
          description: config[:title],
          endpoint: config[:endpoint],
          count: count
        }
      end
    end.compact
  end
  
  def self.parse_config(path)
    return nil unless File.exists?(path)
    File.read(path).each_line.map do |line|
      tokens = line.gsub(/^#.*$/, '').split
      tokens[0..1] if tokens.length == 2
    end.compact.to_h
  end

  def self.find(name)
    config = parse_config(File.join(Settings.library_root, name, 'index.ini')).symbolize_keys
    templates = Dir.glob(File.join(Settings.library_root, name, '*.rq')).select{ |file| File.file?(file) }.map do |file|
      file_name = File.basename(file, '.*')
      parsed = parse_template(file)
      {
        uri: "#{ Settings.root_url }/#{name}/#{file_name}", # TODO: assign unique ID
        name: file_name,
        description: parsed[:description],
        parameters: parsed[:params],
        endpoint: config[:endpoint] #TODO: There may be specific endpoints for each sparql 
      }
    end.compact
    {
      name: name,
      description: config[:title],
      endpoint: config[:endpoint],
      schema: config[:schema],
      templates: templates
    }
  end

  def self.find_template(library_id, template_id)
    config = parse_config(File.join(Settings.library_root, library_id, 'index.ini')).symbolize_keys
    file_path = File.join(Settings.library_root, library_id, "#{template_id}.rq")
    parsed = parse_template(file_path).symbolize_keys
    {
        name: template_id,
        library_name: library_id,
        description: parsed[:description],
        parameters: parsed[:params],
        query: `spang/bin/spang mbgd #{file_path} -r spang/etc/prefix,spang/user_prefix -q`,
        endpoint: config[:endpoint]
    }
  end

  def self.search_template(query)
    results = []
    entries = parse_config(File.join(Settings.library_root,'index.ini'))
    keywords = query.split.map(&:downcase)
    entries.map do |dir, lib_name|
      config = parse_config(File.join(Settings.library_root, dir, 'index.ini')).symbolize_keys
      Dir.glob(File.join(Settings.library_root, dir, '*.rq')).select{ |file| File.file?(file) }.each do |template|
        parsed = parse_template(template).symbolize_keys
        file_name = File.basename(template, '.*')
        if keywords.all?{ |keyword| [lib_name, parsed[:description]].any?{ |txt| txt&.downcase.include?(keyword) } }
          results << {
              name: file_name,
              path: Rails.application.routes.url_helpers.library_show_template_path(dir, file_name),
              library_name: lib_name,
              description: parsed[:description],
              parameters: parsed[:params],
              # query: `spang/bin/spang mbgd #{file_path} -r spang/etc/prefix,spang/user_prefix -q`,
          }
        end
      end
    end.compact
    results.group_by{ |r| r[:library_name] }
  end
end

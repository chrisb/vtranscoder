class VTranscoder
  
  attr_accessor :source
  
  FFMPEG_OPTIONS = {
    :b => 800,
    :r => 25,
    :vcodec => 'flv',
    :acodec => 'libmp3lame',
    :ab => 128,
    :ar => 44100
  }
  
  def self.retrieve(url)
    # download a file to a temporary location and return a VTranscoder object referencing it
  end
  
  def initialize(source)
    @source = source
    verify_source_exists
  end
  
  def convert_with_options(destination,options)
    verify_ffmpeg_exists
    run_ffmpeg options, destination
  end
  
  def convert(destination)
    convert_with_options destination, FFMPEG_OPTIONS
  end
  
  protected
  
  def run(command,parameters)
    actual_command = "#{command} #{parameters}"
    `#{actual_command}`
  end
  
  def run_ffmpeg(options,outputfile)
    run('ffmpeg',"#{command_params options.merge({ :i => @source})} #{outputfile}")
  end
  
  def command_params(hsh)
    hsh.each_key.map { |key| "-#{key.to_s} #{hsh[key]}" }.join(' ')
  end
  
  def verify_source_exists
    raise "unable to open source file (#{@source})" unless File.exists?(@source)
  end
  
  def verify_ffmpeg_exists
    raise "unable to locate ffmpeg binary" if `which ffmpeg` == ''
  end
  
end
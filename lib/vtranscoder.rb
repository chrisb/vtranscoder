# VTranscoder is a utility/convienece class for transcoding video. More specificially it provides any easy-to-use
# interface for FFMPEG which VTranscoder depends on. Zero-configuration default options are provided for converting
# video to Flash (FLV) format, commonly used for delivering web video.
#
# Feel free to contribute because I'm no expert on FFMPEG or it's complex configuration options.
#
# @author Chris Bielinski <chris@shadowreactor.com>
#
class VTranscoder
  
  attr_accessor :source, :meta
  
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
    @meta = {}
    get_video_information
  end
  
  def duration_in_seconds
    # 00:21:41.18
    ( $1.to_i * 60 * 60 ) + ( $2.to_i * 60 ) + ( $3.to_i ) + ( ($4.to_i/100) * 60 ) if @meta[:duration] =~ /([0-9][0-9])\:([0-9][0-9])\:([0-9][0-9])\.([0-9][0-9])/
  end
  
  # options[:at] => number of seconds into video to take the screenshot
  # options[:size] => desired pixel dimensions of screenshot (default is '320*240')
  # options[:to] => path to destination image (/path/to/some/image.jpg)
  def take_screenshot(options)
    verify_ffmpeg_exists
    verify_source_exists
    options = { :size => '320*240' }.merge(options)
    
    ffmpeg_options = {
      :i => @source,
      :y => '',
      :ss => options[:at],
      :sameq => '',
      :t => '0.001',
      :s => options[:size]
    }
    
    output = run_ffmpeg( ffmpeg_options, options[:to], true )
    raise "unable to take screenshot:\n\n#{output}" unless File.exists?(options[:to])
  end
  
  def get_video_information
    verify_ffmpeg_exists
    verify_source_exists

    # Sample FFMPEG output
    #
    # Input #0, avi, from 'video.filename.avi':
    #   Duration: 00:21:41.18, start: 0.000000, bitrate: 1126 kb/s
    #     Stream #0.0: Video: mpeg4, yuv420p, 624x352 [PAR 1:1 DAR 39:22], 23.98 tbr, 23.98 tbn, 23.98 tbc
    #     Stream #0.1: Audio: mp3, 48000 Hz, stereo, s16, 128 kb/s

    ffmpeg_output = `ffmpeg -i #{@source} 2>&1` # we know we're going to get an error but we want to capture 
                                                # the output anyways, so 2>&1 routes STDERR to STDOUT
    
    @meta[:size] = File.size(@source)
    @meta[:duration] = $1 if ffmpeg_output =~ /Duration\: ([0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9])\,/
    @meta[:bitrate] = $1 if ffmpeg_output =~ /\, bitrate\: (.*)$/
    
    @meta[:streams] = []
    ffmpeg_output.scan(/Stream #0.([0-9]): (.*): (.*), (.*)/).each do |match|
      @meta[:streams][match[0].to_i] = { :type => match[1], :codec => match[2], :details => match[3] }
    end
  end
  
  def convert_with_options(destination,options)
    verify_ffmpeg_exists
    run_ffmpeg options, destination
  end
  
  def convert(destination)
    convert_with_options destination, FFMPEG_OPTIONS
  end
  
  def file
    verify_source_exists
    File.open(@source)
  end
  
  protected
  
  def run(command,parameters,reroute_output=false)
    actual_command = "#{command} #{parameters}#{' 2>&1' if reroute_output}"
    puts " ===> #{actual_command}"
    `#{actual_command}`
  end
  
  def run_ffmpeg(options,outputfile,reroute_output=false)
    run('ffmpeg',"#{command_params options.merge({ :i => @source})} #{outputfile}",reroute_output)
  end
  
  def command_params(hsh)
    hsh.each_key.map { |key| "-#{key.to_s}#{ hsh[key].to_s == '' ? '' : ' '+hsh[key].to_s }" }.join(' ')
  end
  
  def verify_source_exists
    raise "unable to open source file (#{@source})" unless File.exists?(@source)
  end
  
  def verify_ffmpeg_exists
    raise "unable to locate ffmpeg binary" if `which ffmpeg` == ''
  end
  
end
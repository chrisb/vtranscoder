# vtranscoder

VTranscoder is a collection of utility methods for transcoding and 'publishing' videos with FFMPEG. The goal of this project is to make transcoding video to web formats like FLV and commonly associated tasks easier. 

VTanscoder also provides connivence methods for taking screenshots, uploading to S3/CloudFront etc.

## Dependencies

You'll need FFMPEG and libmp3lame (if you want to use the default MP3 conversion options).

If you're on Mac OSX:

    sudo port install ffmpeg
    
If you're on Fedora:
    
    yum install ffmpeg
    
For Ubuntu:

    apt-get install ffmpeg

## Installation

Installation is really simple--thanks Gemcutter!

    gem install vtranscoder

## Getting Started

Consider this block of code:

    require 'rubygems'
    require 'vtranscoder'

    # open a video
    @video = VTranscoder.new('/path/to/some/video.avi')

    # how big is the file?
    puts "File size: #{@video.meta[:size]}"

    # print more information
    puts "Meta data: #{@video.meta.inspect}"
    puts "Duration (seconds): #{@video.duration_in_seconds}"

    # take five equally spaced out screenshots
    5.times do |i|
      @video.take_screenshot :at => (@video.duration_in_seconds/5)*i, :to => "screenshot_#{i}.jpg"
    end

    # create Flash video from it
    @video.convert 'video-transcoded.flv'
    
## Advanced Usage

Should you need to pass your own options to the FFMPEG command-line binary, most methods (with the exception of *convert*) take an optional _options_ hash, which is structured as such:

    some_ffmpeg_options_hash = {
      :i => @source,
      :y => '',
      ...
    }

(Notice how the "-y" flag is represented by an empty string.)

You can use *convert_with_options* to start conversion with your own options hash:

    @video.convert_with_options('outfile.mpg',{
      :b => "200"
    })
    
The default options for FLV conversion used with *convert* are:
  
    FFMPEG_OPTIONS = {
      :b => 800,
      :r => 25,
      :vcodec => 'flv',
      :acodec => 'libmp3lame',
      :ab => 128,
      :ar => 44100
    }

## Copyright

Copyright (c) 2009 Chris Bielinski. See LICENSE for details.

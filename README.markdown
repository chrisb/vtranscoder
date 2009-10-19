# vtranscoder

Description goes here.

## Getting Started

Consider this block of code:

    require 'lib/vtranscoder'

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

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Chris Bielinski. See LICENSE for details.

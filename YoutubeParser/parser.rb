require 'rubygems'
out = File.open( "video_id_list.txt" , "w" );
sum = 0
File.open( "html_data.txt" , "r" ) do |f|
  f.each_line do |line|
    if line.include?" <a is=\"yt-endpoint\" class=\"style-scope ytd-playlist-video-renderer\" "
      sum+=1
      temp = line.partition("watch?v=")
      temp2= temp[2].partition("&amp")
      puts temp2[0]
      if sum <= 1000
        out.puts temp2[0]
      end
    end
  end
end
puts sum
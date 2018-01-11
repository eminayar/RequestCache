require 'json'

class Temp
  def initialize( id=0 , title="" , youtubeid="" , timestamp = 0 )
    @id=id
    @title=title
    @youtubeId=youtubeid
    @timestamp=timestamp
  end
  def id
    @id
  end
  def title
    @title
  end
  def youtubeId
    @youtubeId
  end
  def timestamp
    @timestamp
  end
end

class VideosController < ApplicationController
  def new

  end

  def show
    @video = Video.find( params[:id] )
    @goto = @video.timestamp
    if (params[:id].to_i)%20 != 0
      @goto = Video.find( params[:id].to_i+20-(params[:id].to_i)%20 ).timestamp
    end
  end

  def index
    if params[:timestamp].nil?
      path = File.join( Rails.root , "tmp/1514072641.json" )
    else
      path = File.join( Rails.root , "tmp/"+params[:timestamp].to_s+".json" )
    end
    if File.exist?( path )
      @videos = []
      f=File.read( path )
      data=JSON.parse( f )
      titles=data["titles"]
      ids=data["ids"]
      youtubeIds=data["youtubeIds"]
      timestamps=data["timestamps"]
      size=titles.size
      (0..(size-1)).each do |i|
        @videos << Temp.new( ids[i] , titles[i] , youtubeIds[i] , timestamps[i] )
      end
      @pagenum=data["pagenum"]
      @prev=data["prev"]
      @next=data["next"]
    else
      video=Video.find_by_timestamp( params[:timestamp] )
      if !video.nil? && video.id != 1000
        while Video.find( (video.id)+1 ).timestamp.to_s == params[:timestamp].to_s
          if (video.id%20).equal?0
            break
          end
          video=Video.find( video.id+1 )
        end
      end
      if video.nil? || !((video.id%20).equal?0)
        id=1
      else
        id=video.id-19
      end
      @pagenum=(id/20)+1
      @videos=Video.find_each( start: id, finish: id+19 )
      if id != 1
        @prev = Video.find( id-1 ).timestamp
      end
      if id+39 <= 1000
        @next= Video.find( id+39 ).timestamp
      else
        @next= Video.find( 1000 ).timestamp
      end
      titles= []
      ids = []
      youtubeIds = []
      timestamps = []
      @videos.each do |vd|
        titles << vd.title.to_s
        ids << vd.id.to_s
        youtubeIds << vd.youtubeId.to_s
        timestamps << vd.timestamp.to_s
      end
      hsh = {
          "titles" => titles,
          "ids" => ids,
          "youtubeIds" => youtubeIds,
          "timestamps" => timestamps,
          "pagenum" => @pagenum,
          "prev" => @prev,
          "next" => @next
      }
      File.open(path , "w") do |f|
        f.write( JSON.pretty_generate(hsh) )
      end
    end

  end

  def create
    @video = Video.new( params.require(:video).permit(:title,:youtubeId,:commentCount,:dislikeCount,
                                                      :likeCount,:viewCount,:channelId,:channelTitle,:timestamp) )
    @video.save
    redirect_to videos_path
  end
end

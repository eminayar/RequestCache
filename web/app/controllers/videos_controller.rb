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
    @video=Video.find_by_timestamp( params[:timestamp] )
    if !@video.nil? && @video.id != 1000
      while Video.find( (@video.id)+1 ).timestamp.to_s == params[:timestamp].to_s
        if (@video.id%20).equal?0
          break
        end
        @video=Video.find( @video.id+1 )
      end
    end
    if @video.nil? || !((@video.id%20).equal?0)
      @id=1
    else
      @id=@video.id-19
    end
    @pagenum=(@id/20)+1
    @videos=Video.find_each( start: @id, finish: @id+19 )
    if @id != 1
      @prev = Video.find( @id-1 ).timestamp
    end
    if @id+39 <= 1000
      @next= Video.find( @id+39 ).timestamp
    end
  end

  def create
    @video = Video.new( params.require(:video).permit(:title,:youtubeId,:commentCount,:dislikeCount,
                                                      :likeCount,:viewCount,:channelId,:channelTitle,:timestamp) )
    @video.save
    redirect_to videos_path
  end
end

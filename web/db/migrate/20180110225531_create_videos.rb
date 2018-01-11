class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :youtubeId
      t.integer :commentCount
      t.integer :dislikeCount
      t.integer :likeCount
      t.integer :viewCount
      t.string :channelId
      t.string :channelTitle
      t.integer :timestamp

      t.timestamps
    end
  end
end

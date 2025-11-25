namespace :data do
  desc "Update existing Videos with their channel_id based on their youtube_id"
  task update_channel_ids: :environment do
    
    # チャンネルIDを定数として定義
    JARUTOWER_ID = "UChwgNUWPM-ksOP3BbfQHS5Q"
    JARAISLAND_ID = "UCf-wG6PlxW7rpixx1tmODJw"

    allowed_channel_ids = [JARUTOWER_ID, JARAISLAND_ID]

    puts "Starting to update channel_id for existing videos..."
    
    # channel_idがまだ空の全ての動画を取得
    videos_to_update = Video.where(channel_id: nil)

    total_updated = 0
    total_skipped = 0

    videos_to_update.find_each do |video|
      # YouTubeServiceを使って、動画の情報を再取得
      info = YoutubeService.get_video_info(video.youtube_id)

      if info && allowed_channel_ids.include?(info[:channel_id].to_s)
        # 情報が取得でき、許可されたチャンネルIDであれば更新
        video.update_column(:channel_id, info[:channel_id])
        total_updated += 1
        print "."
      else
        # 取得失敗、またはチャンネルIDが不正な場合はスキップ
        total_skipped += 1
        print "s"
      end
    end

    puts "\n--- Update complete ---"
    puts "Successfully updated: #{total_updated} videos."
    puts "Skipped (e.g., info not found/invalid channel): #{total_skipped} videos."
  end
end
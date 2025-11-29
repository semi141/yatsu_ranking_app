FactoryBot.define do
  factory :watch do
    # 関連付け (Association): user_a の視聴記録であることを示す
    association :user 

    # 視聴記録の属性
    sequence(:youtube_id) { |n| "VIDEO_ID_#{n}" } # ユニークな動画IDを生成
    count { 1 } # デフォルトの視聴回数
  end
end
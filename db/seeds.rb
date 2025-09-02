# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 既存のデータを削除（開発環境のみ）
if Rails.env.development?
  puts "既存のデータを削除中..."
  Post.destroy_all
  Category.destroy_all
  User.destroy_all
  puts "既存のデータを削除しました。"
end

# サンプルユーザーの作成
users_data = [
  {
    name: "田中太郎",
    email: "tanaka@example.com",
    password: "password123",
    profile: "プログラミング学習中です。Ruby on Railsを勉強しています。よろしくお願いします！"
  },
  {
    name: "佐藤花子",
    email: "sato@example.com", 
    password: "password123",
    profile: "Webデザインとフロントエンド開発に興味があります。継続の力を信じて頑張ります。"
  },
  {
    name: "鈴木一郎",
    email: "suzuki@example.com",
    password: "password123", 
    profile: "毎日コードを書くことを目標にしています。小さな積み重ねが大きな成果を生むと信じています。"
  },
  {
    name: "山田美咲",
    email: "yamada@example.com",
    password: "password123",
    profile: "新しい技術を学ぶことが好きです。継続は力なり！一緒に頑張りましょう。"
  },
  {
    name: "高橋健太",
    email: "takahashi@example.com",
    password: "password123",
    profile: "バックエンド開発を専門にしています。効率的なコードを書くことを心がけています。"
  }
]

users_data.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.password = user_data[:password]
    user.password_confirmation = user_data[:password]
    user.profile = user_data[:profile]
  end
end

puts "#{users_data.length}人のサンプルユーザーを作成しました。"

# 基本カテゴリの作成（既存のスキーマに基づく）
basic_categories = [
  "仕事・キャリア",
  "人間関係", 
  "健康・生活習慣",
  "SNS・デジタル",
  "お金・消費",
  "その他"
]

basic_categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

puts "#{basic_categories.length}個のカテゴリーを作成しました。"

# 「やらないこと」のサンプル投稿の作成
not_doing_posts = [
  {
    user_email: "tanaka@example.com",
    category_name: "仕事・キャリア", 
    post: "今日は残業をしませんでした",
    reason: "プライベートの時間を大切にして、心身の健康を保ちたいから。仕事とプライベートのバランスを取ることで、明日もより良いパフォーマンスを発揮できると思う。",
    is_draft: false,
    recorded_on: Date.today
  },
  {
    user_email: "sato@example.com",
    category_name: "SNS・デジタル",
    post: "スマートフォンを見る時間を制限しました",
    reason: "無意識にスマホを触る時間が増えていたので、意識的に制限することで集中力を高めたい。リアルな体験や人とのコミュニケーションに時間を使いたいから。",
    is_draft: false,
    recorded_on: Date.today - 1
  },
  {
    user_email: "suzuki@example.com", 
    category_name: "お金・消費",
    post: "衝動的な買い物をやめました",
    reason: "必要でないものを買ってしまう癖があったので、一度立ち止まって考える時間を作ることにした。本当に必要なものにお金を使いたいから。",
    is_draft: false,
    recorded_on: Date.today - 1
  },
  {
    user_email: "yamada@example.com",
    category_name: "人間関係",
    post: "愚痴を言うのをやめました",
    reason: "ネガティブな話題が多くなっていたので、もっとポジティブな会話を心がけたい。自分も周りの人も気持ちよく過ごせる環境を作りたいから。",
    is_draft: false,
    recorded_on: Date.today - 2
  },
  {
    user_email: "takahashi@example.com",
    category_name: "健康・生活習慣",
    post: "夜更かしをやめて早く寝ました",
    reason: "睡眠不足で体調を崩すことが多かったので、規則正しい生活リズムを作りたい。十分な睡眠で健康を維持し、日中のパフォーマンスを向上させたいから。",
    is_draft: false,
    recorded_on: Date.today
  },
  {
    user_email: "tanaka@example.com",
    category_name: "その他",
    post: "完璧主義をやめました",
    reason: "全てを完璧にしようとして疲れてしまうことが多かったので、80%の完成度で満足することにした。自分に優しくして、心の余裕を持ちたいから。",
    is_draft: false,
    recorded_on: Date.today - 3
  },
  {
    user_email: "sato@example.com",
    category_name: "SNS・デジタル", 
    post: "他人のSNSと自分を比較するのをやめました",
    reason: "SNSで他人の投稿を見て落ち込むことがあったので、自分のペースで生活することを大切にしたい。自分なりの幸せを見つけたいから。",
    is_draft: false,
    recorded_on: Date.today - 2
  }
]

not_doing_posts.each do |post_data|
  user = User.find_by(email: post_data[:user_email])
  category = Category.find_by(name: post_data[:category_name])
  
  if user && category
    Post.find_or_create_by!(
      user: user,
      post: post_data[:post],
      recorded_on: post_data[:recorded_on]
    ) do |post|
      post.category = category
      post.reason = post_data[:reason]
      post.is_draft = post_data[:is_draft]
    end
  end
end

puts "#{not_doing_posts.length}件の「やらないこと」のサンプル投稿を作成しました。"

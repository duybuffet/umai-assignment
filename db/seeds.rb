require 'activerecord-import'
require 'faker'
require 'pry'

app_files = File.expand_path('../../app/models/*.rb', __FILE__)
Dir.glob(app_files).each { |file| require(file) }

puts '~> Begin running seeds'

puts '~> Deleting data'
Rating.destroy_all
Feedback.destroy_all
Post.destroy_all
User.destroy_all

puts '~> Creating authors'
100.times.each do |t|
  User.create(login: Faker::Internet.username(specifier: 10))
end

puts '~> Creating posts'
ip_list = 50.times.map { |t| Faker::Internet.public_ip_v4_address }
user_ids = User.pluck(:id)
owner_ids = (1..50).to_a


250_000.times.each_slice(1_000).with_index(1) do |slice, index|
  puts "Importing slice #{index}"
  import_posts = []
  slice.each do |_t|
    post = Post.new(
      user_id: user_ids.sample,
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph(sentence_count: (5..10).to_a.sample),
      author_ip: ip_list.sample
    )
    import_posts << post
  end
  Post.import(import_posts)
end

puts '~> Creating feedbacks'
feedbacked_users = User.where(id: user_ids)
50.times do |t|
  Feedback.create(owner_id: owner_ids.sample, comment: Faker::Lorem.sentence, feedbackable: feedbacked_users[t])
end

10_000.times.each_slice(1_000).with_index(0) do |slice, index|
  puts "Importing slice #{index + 1}"

  feedbacked_posts = Post.limit(1_000).offset(1_000 * index)

  import_feedbacks = []
  slice.each.with_index(0) do |_t, idx|
    feedback = Feedback.new(owner_id: owner_ids.sample, comment: Faker::Lorem.sentence, feedbackable: feedbacked_posts[idx])
    import_feedbacks << feedback
  end
  Feedback.import(import_feedbacks)
end

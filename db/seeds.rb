# Admin user
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name                  = "Admin User"
  user.password              = "foobar"
  user.password_confirmation = "foobar"
  user.birthday              = Date.new(1995, 1, 1)
  user.gender                = :male
  user.admin                 = true
  user.activated             = true
  user.activated_at          = Time.zone.now
end

# 99 regular users
99.times do |n|
  name     = Faker::Name.name
  email    = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = Date.new(1990 + rand(10), rand(1..12), rand(1..28))
  gender   = [:male, :female].sample

  User.find_or_create_by!(email: email) do |user|
    user.name                  = name
    user.password              = password
    user.password_confirmation = password
    user.birthday              = birthday
    user.gender                = gender
    user.activated             = true
    user.activated_at          = Time.zone.now
  end
end

# Microposts for first 6 users
users = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users     = User.all
user      = users.first
following = users[2..20]
followers = users[3..15]
following.each do |followed|
  user.follow(followed) unless user.following?(followed)
end

followers.each do |follower|
  follower.follow(user) unless follower.following?(user)
end


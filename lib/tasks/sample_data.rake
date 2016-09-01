namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        User.create!(name: "Example User",
                     email: "example@railstutorial.org",
                     password: "foobar",
                     password_confirmation: "foobar")
        99.times do |n|
            name = Faker::Name.name
            email = "example-#{n+1}@railstutorial.org"
            User.create!(name: name,
                         email: email,
                         password: "foobar",
                         password_confirmation: "foobar")
        end
        users = User.order(:created_at).take(6)
        50.times do
            content = Faker::Lorem.sentence(5)
            users.each { |user| user.microposts.create!(content: content) }
        end
    end
end
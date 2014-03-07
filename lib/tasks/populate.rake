namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    # [Category, Product, User].each(&:delete_all)
    # User.populate 20 do |user|
    #   user.username    = Faker::Internet.user_name
    #   user.git_username  = Faker::Internet.user_name
    #   user.email   = Faker::Internet.email
    #   user.encrypted_password = User.new(:password => "password").encrypted_password
    # end

    for id in 13..33
      Post.populate 5 do |post|
        post.title = Faker::Lorem.sentence
        post.desc = Faker::Lorem.sentences(2)
        post.slug = Faker::Internet.slug
        post.git_raw_url = "http://www.github.com/mattboldt/gitblog/"
        post.user_id = id
        post.body = Faker::Lorem.paragraphs(5)
        post.git_file_name = post.title.gsub(" ", "-")
        post.git_commit_message = "Committing a file"
        post.git_url = "http://www.github.com/mattboldt/gitblog/"
      end
    end

#  id                 :integer          not null, primary key
#  title              :string(255)
#  slug               :string(255)
#  git_raw_url        :string(255)
#  user_id            :integer
#  body               :text
#  created_at         :datetime
#  updated_at         :datetime
#  git_file_name      :string(255)
#  git_commit_message :string(255)
#  desc               :string(255)
#  git_url            :string(255)
#  git_created_at     :string(255)
#
  end
end
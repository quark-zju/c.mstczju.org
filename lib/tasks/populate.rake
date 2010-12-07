# coding: utf-8

require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "quark",
                 :nick => "quark",
                 :email => "quark@lihdd.net",
                 :group => "admin",
                 :password => "krauq",
                 :password_confirmation => "krauq")
    500.times do |n|
      User.create!(:name => "name#{n}",
                   :nick => "nick#{n}",
                   :email => "test#{n}@null.com",
                   :password => "foobar",
                   :password_confirmation => "foobar")
    end
    Contest.create!(:start_time => 3.days.ago, 
                    :freeze_time => -1.days.ago,
                    :end_time => -30.days.ago, :name => '没有巧克力的比赛')
    Contest.create!(:start_time => -8990.days.ago, 
                    :freeze_time => -8999.days.ago,
                    :end_time => -9000.days.ago, 
                    :name => '下一代人的比赛')
  end
end



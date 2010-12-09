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
                   :group => "contestant",
                   :password => "foobar",
                   :password_confirmation => "foobar")
    end
    Contest.create!(:start_time => 3.days.ago, 
                    :freeze_time => -1.days.ago,
                    :visible_group => 'contestant',
                    :end_time => -30.days.ago, :name => '没有巧克力的比赛')
    Contest.create!(:start_time => -8990.days.ago, 
                    :freeze_time => -8999.days.ago,
                    :visible_group => 'contestant',
                    :end_time => -9000.days.ago, 
                    :name => '下一代人的比赛')

    ["抢整",
      "让寒仔gg和水寒mm聊天吧",
      "拯救苦力光哥",
      "海豹行动",
      "MSTC数学课堂",
      "抢U盘",
      "铁甲依然在",
      "Ghost Instrumentality Program",
      "孙燕姿哪首歌最好听",
      "板砖",
      "Skating",
      "A+B",
      "整数求和"].each { |title|
      Problem.create!(:title => title, :memory_limit => 32, :time_limit => 3)
    }

    (1..13).each { |t|
      ProblemLink.create!(:problem_id => t, :contest_id => 1, :name => t.to_s)
    }

  end
end



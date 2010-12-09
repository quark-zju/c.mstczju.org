#!/usr/bin/ruby
# coding: utf-8
# do not require root permission, require proper ssh config

JUDGE_NO = ARGV[0].to_i


RAILS_ROOT = '.'

load 'config.rb'

require 'active_record'
require 'mysql2'
require 'logger'

#ROOT = File.join(File.dirname(__FILE__), '..')
#['/lib', '/db'].each do |folder|
#	$:.unshift File.join(ROOT, folder)
#end
#require './db/schema'

JUDGE_GROUP_COUNT = JUDGE_GROUP.size
exit if (JUDGE_NO >= JUDGE_GROUP_COUNT) or JUDGE_NO < 0 

ActiveRecord::Base.logger = Logger.new('log/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(RUNENV)


def submission_path(id)
	r = sprintf("%08x", id)
	"./data/s/#{r[0..1]}/#{r[2..3]}/#{r[4..5]}/#{r[6..7]}"
end

def problem_path(id)
	r = sprintf("%06x", id)
	"./data/p/#{r[0..1]}/#{r[2..3]}/#{r[4..5]}"
end

def judge_busy?(name)
	system "pgrep -f 'ssh #{name}'"
end


Dir['models/*.rb'].each { |f| load f }
threads = {}

# single thread, feels better
sleep_time = 0.1
while true do
	# find not judged
	not_judged = Submission.find(:all,
								 :order => 'created_at ASC', 
								 :limit => 1,
								 :conditions => "result = 0")

	if not_judged.size == 0
		sleep_time += 0.5
		sleep_time = 5 if sleep_time > 5
	else
		sleep_time = 0.1
	end
	sleep sleep_time

	not_judged.each do |s|
		j = JUDGE_GROUP[JUDGE_NO]
		s.update_attributes!(:result => 1)

		# run judge
		output = `ssh #{j} '~/run.rb' '#{s.lang}' '#{submission_path(s.id)}' '#{problem_path(s.problem_id)}' '#{s.problem.time_limit}' '#{s.problem.memory_limit}'`

		# get result
		stat, time, memory = 11, nil, nil # 11: internal error
		if output =~ /^Result = (?<stat>.*)$/
			stat = $~[:stat].to_i
		end

		# get memory and time if exist
		time = $~[:time] if output =~ /^Time = (?<time>.*)$/
		memory = $~[:memory] if output =~ /^Memory = (?<memory>.*)$/

		if stat == 2
			# stat == 2 : COMPILE_ERROR
			# write result.lines[2..] to file (only consider first 4k characters) as details log
			info = output[0..4096].split("\n")[1..-1].join("\n")
			info << "\n...." if output.length >= 4096 
			if info.length > 6
				File.open("#{submission_path(s.id)}/log", "w") { |f| f.puts info }
			end
		end

		# do not update anything when Internal Error
		if stat != 11
			# update submit count
			accepted = (stat == 3)
			submit_count, accept_count = s.problem.submit_count, s.problem.accept_count

			accept_count += 1 if accepted
			submit_count += 1

			# update user_cache
			user_cache = UserCache.find(:first, :conditions => [ "user_id = :u and problem_id = :p", { :u => s.user_id, :p => s.problem_id} ]) || UserCache.new(:user_id => s.user_id, :problem_id => s.problem_id)

			if accepted
				user_cache.first_accepted_time ||= s.created_at
			elsif user_cache.first_accepted_time.nil?
				user_cache.attempt = (user_cache.attempt or 0) + 1
			end
			user_cache.save
		end

		s.problem.update_attributes!(:submit_count => submit_count, :accept_count => accept_count)
		s.update_attributes!(:result => stat, :used_time => time, :used_memory => memory)
	end
end



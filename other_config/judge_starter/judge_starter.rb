#!/usr/bin/ruby
# coding: utf-8
# do not require root permission, require proper ssh config

JUDGE_NO = ARGV[0].to_i

# detect duplicate running
pid_file = "/tmp/judge_starter.#{JUDGE_NO}.pid"
if File.exist? pid_file
	# check exist
	pid = File.read(pid_file).to_i
	begin
		if Process.kill(0, pid)
			puts "Judge No.#{JUDGE_NO} is already running."
			exit
		end
	rescue
	end
end

# mark as running
File.open(pid_file, 'w') do |f|
	f.puts Process.pid
end

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
start_time, judge_count = Time.now, 0
sleep_time = 0.1
while true do
	unless File.exist? pid_file
		# exit if pid file missing
		puts "Exiting..."
		exit
	end
	# find not judged, update it as judging in transaction
	s = nil
	sleep sleep_time

	Submission.transaction do
		s = Submission.find_by_sql("SELECT * FROM submissions WHERE result = 0 ORDER BY id ASC LIMIT 1")
		# seems that use ActiveRecord.find method, order is somehow ignored -.-
		#					(:first,
		#					:order => 'id ASC', 
		#					:conditions => "result = 0")
		if s.size == 0
			s = nil
			sleep_time += 0.1
			sleep_time = 3.5 if sleep_time > 3.5
		else
			s = s.first
			sleep_time = 0.0
			s.update_attributes!(:result => 1)
			break # skip sleep to begin judge that submission
		end
	end

	next if s.nil?

	# not_judged.each do |s|
	j = JUDGE_GROUP[JUDGE_NO]

	# run judge
	id = s.id
	print "#{id}: "
	command = "ssh #{j} '~/run.rb' '#{s.lang}' '#{submission_path(id)}' '#{problem_path(s.problem_id)}' '#{s.problem.time_limit}' '#{s.problem.memory_limit}'"
	# this may cause error, just retry:
	loop_flag = true
	while loop_flag
		begin
			output = `#{command}`
			loop_flag = false
		rescue
			puts 'ssh command failed, retry in 5 seconds'
			sleep 5
			loop_flag = true
		end
	end

	# get result
	stat, time, memory = 11, nil, nil # 11: internal error
	if output =~ /^Result = (?<stat>.*)$/
		stat = $~[:stat].to_i
	end

	# get memory and time if exist
	time = $~[:time] if output =~ /^Time = (?<time>.*)$/
		memory = $~[:memory] if output =~ /^Memory = (?<memory>.*)$/

		log_file = "#{submission_path(s.id)}/log"
		if stat == 2 or stat == 11
			# stat == 2 : COMPILE_ERROR || INTERNAL_ERROR
			# write result.lines[2..] to file (only consider first 4k characters) as details log
			info = output[0..4096].split("\n")[1..-1].join("\n")
			info << "\n...." if output.length >= 4096 
			File.open(log_file, "w") { |f| f.puts info }
		elsif File.exist? log_file
			# remove log if it should be none
			File.delete log_file rescue nil
		end

	puts "#{stat}"

	# do not update anything when Internal Error
	if stat != 11
		accepted = (stat == 3)
		# update submit count
		Problem.transaction do
			submit_count, accept_count = s.problem.submit_count || 0, s.problem.accept_count || 0

			accept_count += 1 if accepted
			submit_count += 1

			s.problem.update_attributes!(:submit_count => submit_count, :accept_count => accept_count)
		end

		# update user_cache
		UserCache.transaction do 
			user_cache = UserCache.find(:first, :conditions => [ "user_id = :u and problem_id = :p", { :u => s.user_id, :p => s.problem_id} ]) || UserCache.new(:user_id => s.user_id, :problem_id => s.problem_id)

			if accepted
				user_cache.first_accepted_time ||= s.created_at
			elsif user_cache.first_accepted_time.nil?
				user_cache.attempt = (user_cache.attempt || 0) + 1
			end
			user_cache.save
		end
	end

	s.update_attributes!(:result => stat, :used_time => time, :used_memory => memory)

	if (judge_count += 1) % 16 == 0
		puts "#{Time.now - start_time} sec : #{judge_count} submissions"
	end
	# end
end



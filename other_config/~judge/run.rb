#!/usr/bin/ruby
# coding: utf-8

require 'fileutils'

lang, submission_path, problem_path, time_limit, memory_limit = ARGV
user, uid = ENV['USER'], Process.uid
sandbox_root = "/sandboxroot/#{user}"
user_prefix = "/tmp/ram/#{user}"

@files_to_cleanup = [ 
	"#{user_prefix}_compile_error", 
	"#{user_prefix}_compile_output", 
	"#{user_prefix}_run_error", 
	"#{user_prefix}_run_output", 
	"#{user_prefix}_p1.lua", 
	"#{user_prefix}_p2.lua", 
	"#{sandbox_root}/tmp/", 
]

#['尚未评测', '正在评测', '编译错误', '答案正确', '格式错误', 
# '答案错误', '运行超时', '内存溢出', '段错误', '运行出错', 
# '非法代码', '内部错误']

def output_result(code, result)
	puts "Result = #{code}"
	puts result
	# CLEAN UP
	clean_up
	exit
end

def file_content(file)
	if File.exists?(file)
		File.read(file) 
	else
		''
	end
end

def clean_up
	@files_to_cleanup.each { |f| FileUtils.remove_entry_secure f, true }
end

begin
	output_result(11, 'ARGV.size < 5') if memory_limit.nil?
	clean_up

	# === COMPILE ==========================================================================
	output_result(2, "无效语言") unless File.exist?("./lang/#{lang}/compile.sh")
	FileUtils.cp "#{submission_path}/code", "#{sandbox_root}/tmp/code"
	FileUtils.cp "./lang/#{lang}/compile.sh", "#{sandbox_root}/tmp/compile.sh"
	File.chmod 0777, "#{sandbox_root}/tmp/compile.sh"
	# Write compile policy
	policy = File.read("./lang/#{lang}/policy_compile.lua")
	subs = { 
		:OUTPUT => "'/tmp/ram/#{user}_compile_output'",
		:ERROR => "'/tmp/ram/#{user}_compile_error'",
		:UID => uid + 10000, :GID => uid + 1000,
		:TIME => 6.0, :MEMORY => 512.0,
		:DEADLINE => 10.0,
		:CHROOT => "'#{sandbox_root}'",
		:CHDIR => "'/tmp'",
	}

	subs.each do |k, v|
		policy.gsub! Regexp.new(k.to_s), v.to_s
	end
	policy_path = "/tmp/ram/#{user}_p1.lua" 
	File.open(policy_path, 'w') { |f| f.print policy }
	# Run compiler in sandbox (compiler path is in sandbox)
	result = `sudo /sbin/zandbox "#{policy_path}" "/bin/sh" "/tmp/compile.sh"`
	unless (result =~ /^\] STAT EXITTED$/) and File.exist?("#{sandbox_root}/tmp/run")
		content = file_content("/tmp/compile_output") + file_content("/tmp/compile_error")
		content = result if content.length < 5
		output_result 2, content
	end

	# === RUN ==============================================================================
	policy = File.read("./lang/#{lang}/policy_run.lua")
	subs = {
		:OUTPUT => "'#{user_prefix}_run_output'", :ERROR => "'#{user_prefix}_run_error'",
		:INPUT => "'#{ENV['PWD']}/#{problem_path}/input'",
		:UID => uid + 10000, :GID => uid + 1000, :TIME => time_limit, :MEMORY => memory_limit,
		:DEADLINE => (time_limit.to_f + 3).to_s, :CHDIR => "'/tmp'", 
		:CHROOT => "'#{sandbox_root}'",
	}
	subs.each do |k, v|
		policy.gsub! Regexp.new(k.to_s), v.to_s
	end
	policy_path = "/tmp/ram/#{user}_p2.lua" 
	File.open(policy_path, 'w') { |f| f.print policy }
	result = `sudo /sbin/zandbox "#{policy_path}" "/lib/ld-linux.so.2" "/tmp/run"`

	stats_map = { 
		:INTERNAL_ERROR => 11,
        :RESTRICTED_SYSCALL => 10,
        :MEMORY_LIMIT_EXCEED => 7,
        :TIME_LIMIT_EXCEED => 6,
        :OUTPUT_LIMIT_EXCEED => 6, # TODO Assign OLE a number
        :SEGMENTATION_FAULT => 8,
        :MANUALLY_STOP => 9,
        :PROCESS_LIMIT_EXCEED => 9,
	}

#['尚未评测', '正在评测', '编译错误', '答案正确', '格式错误', 
# '答案错误', '运行超时', '内存溢出', '段错误', '运行出错', 
# '非法代码', '内部错误']

	if result =~ /\] STAT (?<stat>.*)$/
		stat = $~[:stat]
		output_result stats_map[stat.to_sym], stat if stats_map[stat.to_sym]
	else
		output_result 11, 'Run final stat missing'
	end


	# === JUDGE ============================================================================
	# direct compare by default
	# compare "#{problem_path}/output" with "#{user_prefix}_run_output"
	out_std = File.read "#{problem_path}/output" 
	out_user = File.read "#{user_prefix}_run_output"

	out_std << "\n" unless out_std.end_with? "\n"
	out_user << "\n" unless out_user.end_with? "\n"

	if out_std == out_user
		time = memory = 0
		if result =~ /^\] TIME (?<time>.*)$/
			time = $~[:time].to_f * 1000
		end
		if result =~ /^\] MEM (?<memory>.*)$/
			memory = $~[:memory].to_f * 10.24 
		end
		# Time: 0.001 s, Memory: 0.1 MB
		output_result 3, "Time = #{time}\nMemory = #{memory}"
	elsif out_std.gsub(/\W/, '') == out_user.gsub(/\W/, '')
		output_result 4
	else
		output_result 5
	end

	# === CLEAN UP =========================================================================
	clean_up

rescue => ex
	output_result 11, "#{ex.class}: #{ex.message}"
end

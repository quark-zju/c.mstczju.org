# Load the rails application
require File.expand_path('../application', __FILE__)

# globar variables
$next_submit_limits = {}

# Dir.mkdir_as_needed
def Dir.mkdir_as_needed(path)
  return if Dir.exist? path
  partial_path = ''
  path.split('/').each do |s|
    partial_path << '/' << s
    Dir.mkdir partial_path unless Dir.exists? partial_path
  end
end

# Initialize the rails application
CContest::Application.initialize!

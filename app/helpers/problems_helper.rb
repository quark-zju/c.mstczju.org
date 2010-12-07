module ProblemsHelper
  def problem_html(problem)
    content = problem.raw_text
    content.gsub(/!\[(?<alt>.*)\]\((?<file>\S*)\)/, '<img src="/images/p/\k<file>" alt="\k<alt>">')
    #image_tag("p/\k<file>", :alt => '\k<alt>')
  end
end

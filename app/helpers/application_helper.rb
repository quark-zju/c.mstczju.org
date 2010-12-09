# coding: utf-8

module ApplicationHelper
  def title
    default_title = '计软学院第五届 C 语言趣味程序设计竞赛'
    if @title then
      "#{@title} | #{default_title}"
    else
      default_title
    end
  end

  def logo
    image_tag("logo.png", :alt => "MSTC C Contest")
  end

  def shorten(string, length = 9)
    if string.length <= length
      string
    else
      "#{string[0..length]}..."
    end
  end
end

# coding: utf-8

class PagesController < ApplicationController
  def home

  end

  def about
    @title = '关于我们'
  end

  def help
    @title = '帮助'
  end


end

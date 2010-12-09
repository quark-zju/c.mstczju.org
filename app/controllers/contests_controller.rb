# coding: utf-8

class ContestsController < ApplicationController
  before_filter :privileged_user, :only => [:edit, :update, :new, :create, :destroy]
  before_filter :correct_time, :only => [:show]

  #caches_page :ranklist

  def index
    @title = '比赛列表'
    @contests = Contest.all
  end

  def show
    #@contest = Contest.find(params[:id])
  end

  def new
    @contest = Contest.new
  end

  def edit
    expire_page :action => 'ranklist'
    @contest = Contest.find(params[:id])
  end

  def create
    @contest = Contest.new(params[:contest])
    if @contest.save
      redirect_to @contest, :notice => '创建成功'
    else
      redirect_to 'new', :notice => '创建失败'
    end
  end

  def update
    @contest = Contest.find(params[:id])
  end

  def destroy
    @contest = Contest.find(params[:id])
    @contest.destroy
  end

  def ranklist
    @title = '比赛排名'
    @contest = Contest.find(params[:id])
    @gen_time = Time.now
    expires_in 1.minute 
  end

  private

  def correct_time
    @contest = Contest.find(params[:id])
    if Time.now < @contest.start_time 
      if is_admin?
        flash.now[:notice] = '该比赛尚未开始'
        return
      end
      redirect_to contests_path, :flash => { :error => '现在还没有到比赛时间' }
    end
  end

  def privileged_user
    if params[:id]
      return if Contest.find(params[:id]).moderate_by?(current_user)
    end
    return if is_admin?
    redirect_to root_path, :flash => { :error => '您无权限访问该页' }
  end
end

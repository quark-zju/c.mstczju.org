# coding: utf-8

class ProblemsController < ApplicationController
  before_filter :privileged_user, :only => [:edit, :update, :new, :create, :destroy, :index]
  before_filter :correct_time, :only => [:show]

  def index
    @problems = Problem.all
  end

  def show
    #@problem = Problem.find(params[:id])
  end

  def new
    @problem = Problem.new
  end

  def edit
    @problem = Problem.find(params[:id])
    expire_action 
  end

  def create
    @problem = Problem.new(params[:problem])

    if @problem.save
      redirect_to(@problem, :notice => 'Problem was successfully created.')
    else
      render :action => "new" 
    end
  end

  def update
    @problem = Problem.find(params[:id])

    if @problem.update_attributes(params[:problem])
      redirect_to(@problem, :notice => 'Problem was successfully updated.') 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @problem = Problem.find(params[:id])
    @problem.destroy

    redirect_to(problems_url) 
  end

  private

  def correct_time
    @problem = Problem.find(params[:id])
    permitted, now = false, Time.now
    @problem.contests.each do |contest|
      if now >= contest.start_time #and now <= contest.end_time
        permitted = true
        break
      end
    end
    if not permitted and is_admin?
      flash.now[:notice] = '非管理员现在还不能查看该题目'
      return
    end
    redirect_to root_path, :flash => { :error => '现在还不能查看该题目' } unless permitted
  rescue
    redirect_to root_path, :flash => { :error => '无法查看该题目' } unless permitted
  end

  def privileged_user
    redirect_to root_path, :flash => { :error => '您无权访问该页' } unless is_admin?
  end
end

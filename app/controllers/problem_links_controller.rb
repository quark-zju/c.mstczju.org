# coding: utf-8

class ProblemLinksController < ApplicationController
  before_filter :privileged_user

  def index
    @problem_links = ProblemLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @problem_links }
    end
  end

  # GET /problem_links/1
  # GET /problem_links/1.xml
  def show
    @problem_link = ProblemLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @problem_link }
    end
  end

  # GET /problem_links/new
  # GET /problem_links/new.xml
  def new
    @problem_link = ProblemLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @problem_link }
    end
  end

  # GET /problem_links/1/edit
  def edit
    @problem_link = ProblemLink.find(params[:id])
  end

  # POST /problem_links
  # POST /problem_links.xml
  def create
    @problem_link = ProblemLink.new(params[:problem_link])

    respond_to do |format|
      if @problem_link.save
        format.html { redirect_to(@problem_link, :notice => 'Problem link was successfully created.') }
        format.xml  { render :xml => @problem_link, :status => :created, :location => @problem_link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @problem_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /problem_links/1
  # PUT /problem_links/1.xml
  def update
    @problem_link = ProblemLink.find(params[:id])

    respond_to do |format|
      if @problem_link.update_attributes(params[:problem_link])
        format.html { redirect_to(@problem_link, :notice => 'Problem link was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @problem_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_links/1
  # DELETE /problem_links/1.xml
  def destroy
    @problem_link = ProblemLink.find(params[:id])
    @problem_link.destroy

    respond_to do |format|
      format.html { redirect_to(problem_links_url) }
      format.xml  { head :ok }
    end
  end

  private

  def privileged_user
    redirect_to root_path, :flash => { :error => '您无权访问该页' } unless is_admin?
  end
end

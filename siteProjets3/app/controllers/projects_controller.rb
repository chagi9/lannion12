class ProjectsController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_annee

  def roll
    @project = Project.find(params[:id])
  end

  def publier
    @project = @annee.projects.find(params[:id])
    @project.invisible = FALSE
    @project.save
    redirect_to(annee_projects_path(@annee))
  end

  def horsligne
    @project.invisible = TRUE
    @project.save
    redirect_to(annee_projects_path(@annee))
  end

  def index
    @projects = @annee.projects.all
    @annees = Annee.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @projects }
    end
  end

  def show
    @project = @annee.projects.find(params[:id])
    @uploads = Upload.where(:project_id => @project.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  def new
    @annee = Annee.find(params[:annee_id])
    @project = @annee.projects.build
    @upload = @project.uploads.build
    #@uploads = Upload.find(:all, :limit => 10, :order => "updated_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @projects }
    end
  end

  def edit
    @project = @annee.projects.find(params[:id])
    @uploads = Upload.where(:project_id => @project.id)
    #@uploads = Upload.find(:all, :limit => 10, :order => "updated_at DESC")
  end

  def create
    @project = @annee.projects.build(params[:project])
    @upload = @project.uploads.build(params[:upload])
    #@uploads = Upload.find(:all, :limit => 10, :order => "updated_at DESC")

    respond_to do |format|
      if @upload.save
        if @project.save
          flash[:notice] = 'Le projet a ete cree.'
          format.html { redirect_to([@annee, @project]) }
          format.xml { render :xml => @project, :status => :created, :location => @project }
        else
          format.html { render :action => "new" }
          format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = @annee.projects.find(params[:id])
    @upload = Upload.where(:project_id => @project.id)

    if @upload.update(@upload,params[:upload])
      respond_to do |format|
        if @project.update_attributes(params[:project])
          flash[:notice] = 'Le projet a ete mis a jour.'
          format.html { redirect_to([@annee, @project]) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @project = @annee.projects.find(params[:id])
    @upload = Upload.where(:project_id => @project.id)
    @upload.destroy(@upload)
    @project.destroy
    flash[:notice] = 'Le projet a ete detruit.'

    respond_to do |format|
      format.html { redirect_to(annee_projects_path(@annee)) }
      format.xml { head :ok }
    end
  end

  private
  def get_annee
    @annee = Annee.find(params[:annee_id])
  end

end

class PagesController < ApplicationController
  layout 'admin'
  before_action :confirm_logged_in
  before_action :find_subject
  before_action :set_page, :only => [:show, :edit, :update, :delete, :destroy]
  # before_action :find_subjects, :only => [:new, :create, :edit, :update] {not needed anymore}
  before_action :set_page_count, :only => [:new, :create, :edit, :update]

  def index
    @pages = @subject.pages.sorted
  end

  def show
  end

  def new
    @page = Page.new(:subject_id => @subject.id)
  end

  def create
    @page = Page.new(page_params)
    @page.subject = @subject
    if @page.save
      flash[:notice] = "page created successfully."
      redirect_to(pages_path(:subject_id => @subject.id))
    else
      render('new')
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      flash[:notice] = "Page updated successfully."
      redirect_to(page_path(@page, :subject_id => @subject.id))
    else
      render ('edit')
    end
  end

  def delete
  end

  def destroy
    @page.destroy
    flash[:notice] = "Page destroyed successfully."
    redirect_to(pages_path(:subject_id => @subject.id))
  end

  private 

  def page_params
    params.require(:page).permit(:name, :position, :visible, :permalink)
  end

  def set_page
    @page = Page.find(params[:id])
  end

  def find_subject
    @subject = Subject.find(params[:subject_id])
  end

  # not needed anymore
  # def find_subjects
  #   @subjects = Subject.sorted
  # end

  def set_page_count
    @page_count = @subject.pages.count
    if params[:action] == 'new' || params[:action] == 'create'
      @page_count += 1
    end
  end
end

class DemoController < ApplicationController
  def index
    @array = {name: 'jill', sign: 'cancer', country: 'usa'}
    @subject = Subject.new
  end

  def hello
    @id = params['id']
    @page = params[:page]
  end
end

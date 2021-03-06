class LibraryController < ApplicationController
  def index
    @libraries = Library.all
  end

  def show
    @library = Library.new(params[:id])
  end

  def show_template
    @template = Library.new(params[:library_id]).templates.select{ |template| template.name == File.basename(params[:template_id], '.*')}.first
    respond_to do |format|
      format.all { render plain: @template.query }
      format.html { render action: 'show_template.html.haml', content_type: "text/html" }
      format.json { render json: { query: @template.query } }
    end
  end

  def search_template
    @query = params[:keyword]
    @template_groups = Template.search(@query)
  end
end